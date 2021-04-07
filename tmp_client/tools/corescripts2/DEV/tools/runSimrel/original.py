import os;
import glob;
import re;
import shutil;
#------------------------globle variable
work_dir=r'X:\strdom\___ttt\DEV2_case';
run_folder = r'_scratch';

#------------------------
lst_name = r'tb.lst';
sim_folder = r'sim_rtl';
#------------------------globle function
def run_main(work_dir, save_dir):
	#for case_list.ini:  #don't support []
	case_list = r'X:\strdom\___ttt\case_list.ini';
	zz = open(case_list);
	all_lines = zz.readlines();
	zz.close();
	#for work_dir_list
	#all_lines = os.listdir(work_dir);
	for z in all_lines:
		z = z.strip();
		if len(z)<1:
			continue;
		design_work = os.path.join(work_dir, z);
		a, design = os.path.split(design_work);
		design_run=os.path.join(design_work, run_folder);
		subsave_dir = os.path.join(save_dir, design);
		try:			
			os.mkdir(subsave_dir);
		except:
			pass;
		set_fc_rbt(design_run, subsave_dir);
		set_fc_avc(design_run, os.path.join(design_run, sim_folder), subsave_dir);

def set_fc_rbt(par_result, save_dir): ##please remove the older rbt files.
	for root, folders, files in os.walk(par_result):
		for zz in files:
			if zz[-4:]==r'.rbt':
				shutil.copy2(os.path.join(root, zz), save_dir);
				os.rename(os.path.join(save_dir, zz), os.path.join(save_dir, 'fc.rbt'));
				return;

def set_fc_avc(par_result, sim_result, save_dir):
	#------------------------------------	
	def chage_HtoB(data_str, bits): #return result = data[0,1,2,3,4,5...]
		result = "";
		for i in range(len(data_str)-1, -1, -1):
			if data_str[i]=='0':
				tmp = '0000';
			elif data_str[i]=='1':
				tmp = '1000';
			elif data_str[i]=='2':
				tmp = '0100';
			elif data_str[i]=='3':
				tmp = '1100';
			elif data_str[i]=='4':
				tmp = '0010';
			elif data_str[i]=='5':
				tmp = '1010';
			elif data_str[i]=='6':
				tmp = '0110';
			elif data_str[i]=='7':
				tmp = '1110';
			elif data_str[i]=='8':
				tmp = '0001';				
			elif data_str[i]=='9':
				tmp = '1001';
			elif data_str[i]=='a':
				tmp = '0101';
			elif data_str[i]=='b':
				tmp = '1101';
			elif data_str[i]=='c':
				tmp = '0011';
			elif data_str[i]=='d':
				tmp = '1011';
			elif data_str[i]=='e':
				tmp = '0111';
			elif data_str[i]=='f':
				tmp = '1111';
			else:
				tmp = 'XXXX';
			result +=tmp;
		while(1):
			if len(result)==bits:
				return result;
			elif len(result)<bits:
				result+='0';
			else:
				result = result[:-1];
			
	#------------------------------------	
	def check_input_avc(port_wave): # not (1 or 0) are change to 0
		if port_wave!='1' and port_wave!='0':
			return '0'
		else:
			return port_wave
	def check_output_avc(port_wave):# not (1 or 0) are change to X
		if port_wave=='1':			
			return 'H'
		elif port_wave=='0':			
			return 'L'		
		else:
			return 'X'
	#------------------------------------
	#convert the list of pad_info and lst_info to dictionary;
	def get_pad_dic(pad_info_list):
		pad_dic = {};
		for zz in pad_info_list:
			pad_dic[zz[0]] = zz[1:];
		return pad_dic;
	def get_lst_dic(lst_info_list):
		lst_dic = {};
		if not lst_info_list:
			return lst_dic;
		for i in range(0, len(lst_info_list[0])):#title
			port = lst_info_list[0][i];			
			bb = [];
			for zz in lst_info_list[1:]:
				bb.append(zz[i]);
			lst_dic[port] = bb;
		return lst_dic;
	#------------------------------------
	lst_dic = get_lst_dic(get_lst_result(sim_result));
	pad_dic = get_pad_dic(get_design_pad(par_result));
	if (not lst_dic) or (not pad_dic):
		if not lst_dic:
			print par_result + '  _______  sim lst result is empty!!!!  ';
		if not pad_dic:
			print par_result + '  _______  pad result is empty!!!!  ';
		return;
	#print lst_dic;
	#print pad_dic;
	#output sequence
	order = [];
	for tkey in pad_dic.keys():
		order.append(tkey);
	fc_avc = open(os.path.join(save_dir, 'fc.avc'),'w');
	#output port name in design
	fc_avc.write('#   port name in design\n');
	fc_avc.write('#   ');
	for zz in order:
		pad_list = pad_dic[zz][0]
		if type(pad_list)==list:
			for i in range(0, len(pad_list)):
				fc_avc.write(zz+'['+str(i)+']'+' '*4);
		else:
			fc_avc.write(zz+' '*4);
	fc_avc.write('\n');
	#output pad name in design
	fc_avc.write('format '+' '*4);
	for zz in order:
		pad_list = pad_dic[zz][0];
		if type(pad_list)==list:
			for i in range(0, len(pad_list)):
				fc_avc.write(pad_list[i].lower()+' '*4);
		else:
			fc_avc.write(pad_list.lower()+' '*4);
	fc_avc.write(';\n');
	#output wave form and golder result(lst result), input port is 0/1, output port is H/L. don't care is X
	##---ignore BIDI port
	for zz in order:
		if pad_dic[zz][1]=='BIDI':
			fc_avc.write('\n\n\n\n');
			fc_avc.write(zz +' is BIDI port, script can not generate the awc files!!!!');
			print par_result + '  _______   have BIDI port. !!!!!!!!!'
			fc_avc.write('\n\n\n\n');
			fc_avc.close();
			return;
	for line in range (0, len(lst_dic[order[0]])):
		fc_avc.write('r1 name  '+' '*4);
		for zz in order:
			pad_list = pad_dic[zz][0];
			pad_io =  pad_dic[zz][1];
			if type(pad_list)==list:
				bits = len(pad_list);
				bits_wav = chage_HtoB(lst_dic[zz][line], bits);
				for tmpi in range (0, bits):
					if pad_io=='IN':
						fc_avc.write(check_input_avc(bits_wav[tmpi]));
					elif pad_io=='OUT':
						fc_avc.write(check_output_avc(bits_wav[tmpi]));
			else:				
				if pad_io=='IN':
					fc_avc.write(check_input_avc(lst_dic[zz][line]));
				elif pad_io=='OUT':
					fc_avc.write(check_output_avc(lst_dic[zz][line]));
		fc_avc.write(';\n');
	fc_avc.close();
	
#output sample as following:
#[['Data', 'Q', 'RdAddress', 'RdClock', 'RdClockEn', 'Reset', 'WE', 'WrAddress', 'WrClock', 'WrClockEn'], ['?', '0', '?', 'X', 'X', 'X', 'X', '?', 'X', 'X'], ['af1c', '0', '0', '0', '0', '0', '1', '0', '0', '1'], ['af1c', '0', '0', '0', '0', '0', '1', '0', '0', '1'], ['af1c', '0', '0', '1', '0', '0', '1', '0', '1', '1'], ['af1c', '0', '0', '1', '0', '0', '1', '0', '1', '1'], ['4a1b', '0', '1', '0', '0', '0', '1', '1', '0', '1'], ['4a1b', '0', '1', '0', '0', '0', '1', '1', '0', '1'], ['4a1b', '0', '1', '1', '0', '0', '1', '1', '1', '1'], ['4a1b', '0', '1', '1', '0', '0', '1', '1', '1', '1'], ['5d95', '0', '2', '0', '0', '0', '1', '2', '0', '1'], ['5d95', '0', '2', '0', '0', '0', '1', '2', '0', '1'], ['5d95', '0', '2', '1', '0', '0', '1', '2', '1', '1'], ['5d95', '0', '2', '1', '0', '0', '1', '2', '1', '1'], ['919d', '0', '3', '0', '0', '0', '1', '3', '0', '1'], ['919d', '0', '3', '0', '0', '0', '1', '3', '0', '1'], ['919d', '0', '3', '1', '0', '0', '1', '3', '1', '1'],
def get_lst_result(sim_result):
	#----------------------------
	def remove_hirk(title_line):
		for i in range(0, len(title_line)):
			zz = title_line[i];
			title_line[i] = zz[zz.rfind(r'/')+1:];
		return title_line;
	#----------------------------
	def remove_ps(lst_line_list):
		try:
			return (lst_line_list[1:]);
		except:
			return [];
	#----------------------------
	#input lst one line:
	def clear_space(lst_line):
		lst_line = lst_line.strip();
		zz = lst_line.split(' ');
		try:
			for i in range (0, len(zz)):
				zz.remove('');
		except:
			return zz;
	#----------------------------
	lst_file = r'';
	for root, folders, files in os.walk(sim_result):
		if lst_name in files:
			lst_file = os.path.join(root, lst_name);
			break;
	lst_result = [];
	if lst_file!=r'':
		zz = open(lst_file);
		all_lines = zz.readlines();
		zz.close();
		for one_line in all_lines:			
			lst_result.append(remove_ps(clear_space(one_line)));
	try:
		lst_result[0] = remove_hirk(lst_result[0])[:];
	except:
		pass
	return lst_result;

#search 5_1.pad to get the package, port_pin name
#output sample as following:
#[('Data', ['PT79A', 'PT80B', 'PT89B', 'PT79B', 'PT91A', 'PT82B', 'PT85A', 'PT86B', 'PT59A', 'PT61A', 'PT64A', 'PT61B', 'PT65A', 'PT65B', 'PT58A', 'PT64B'], 'IN'), ('Q', ['PT86A', 'PT85B', 'PT88A', 'PT83A', 'PT82A', 'PT88B', 'PT80A', 'PT91B', 'PT56B', 'PT59B', 'PT68A', 'PT62B', 'PT56A', 'PT58B', 'PT62A', 'PT46B'], 'OUT'), ('RdAddress', ['PT76B', 'PT73B', 'PT74B', 'PT70B', 'PT71B', 'PT71A'], 'IN'), ('RdClock', 'PT76A', 'IN'), ('RdClockEn', 'PT74A', 'IN'), ('Reset', 'PR14B', 'IN'), ('WE', 'PT89A', 'IN'), ('WrAddress', ['PT67A', 'PT67B', 'PT70A', 'PT68B', 'PT77A', 'PT77B'], 'IN'), ('WrClock', 'PT73A', 'IN'), ('WrClockEn', 'PT83B', 'IN')]
def get_design_pad(par_result):
	#------------------------------------
	def get_package(pad_file):
		zz = open(pad_file);
		all_lines = zz.readlines();
		zz.close();
		for tt in all_lines:
			if tt.find(r'PACKAGE:')==0:
				return tt[tt.find(':')+1:].strip();
	#------------------------------------
	#input [('B1[28]', 'AD3', 'IN'), ('B1[29]', 'P6', 'IN')]
	#             28                  29
	#output: [B1[0, 1, 2, 3,...28,29...], 'AD3', 'P6']
	#how to do.  a. B1 must same, b.get the data in [], map input with data list (('B1[28]', 'AD3') -> 28), c, sort the data list and merge the bus.
	def merge_bus(port_pin):
		suffiex = re.compile('[^\[]+\[\d+\]$', re.I);
		result = [];
		for i in range(0, len(port_pin)):
			zz = port_pin[i][0];
			if suffiex.match(zz):
				bus_str = zz[:zz.find('[')];
				filter_data = [];				
				bus_pat = bus_str+r'\[(\d+)\]$';
				#print bus_pat;
				sub_suffiex = re.compile(bus_pat, re.I);
				t = (int(sub_suffiex.match(zz).group(1)), port_pin[i])
				port_pin[i] = '-';#update
				filter_data.append(t);
				for j in range (i, len(port_pin)):
					aa = sub_suffiex.match(port_pin[j][0]);
					if aa:
						t = (int(aa.group(1)), port_pin[j])
						filter_data.append(t);
						port_pin[j] = '-';#update				
				#sort
				filter_data = sorted(filter_data, key=lambda filter_data: filter_data[0])
				#print filter_data
				if len(filter_data)>1: #get pin
					bb = []
					for aa in filter_data:
						bb.append(aa[1][1]);
					t = (bus_str, bb, filter_data[0][1][2]);
					result.append(t);
				else:
					try:
						result.append(filter_data[1]);
					except:
						t = (bus_str, filter_data[0][1][1], filter_data[0][1][2]);
						result.append(t);
			elif zz!='-':
				result.append(port_pin[i]);
		return result;
	#------------------------------------
	def get_port_pin(pad_file):
		zz = open(pad_file);
		all_lines = zz.readlines();
		zz.close();
		flag = 0;
		start_flag = re.compile(r'\|\s*Port\s*Name\s*\|\s*Pin/Bank\s*\|\s*Buffer\s*Type\s*|\s*Site\*', re.I);
		end_flag = re.compile(r'Vccio\s*by\s*Bank:', re.I);
		port_pin = [];
		for tt in all_lines:
			if start_flag.match(tt):
				flag = 1;
				continue;
			elif end_flag.match(tt):
				flag = 0;
				break;
			elif flag>0:
				if tt[0]==r'|':
					tmp = tt[1:tt.find(r'/')];
					port = tmp[:tmp.find(r'|')].strip();
					#pin = tmp[tmp.find(r'|')+1:].strip();  this is turely pin
					#follwing are for picking the site(is same as avc files)
					b = tt.split('|')
					pin = b[4].strip();
					buf_type = b[3].strip();
					if buf_type[-3:]=='_IN':
						port_pin.append((port, pin, 'IN'));
					elif buf_type[-4:]=='_OUT':
						port_pin.append((port, pin, 'OUT'));
					else:#_BIDI
						port_pin.append((port, pin, 'BIDI'));
		if len(port_pin)>1:
			#port_pin = sorted(port_pin, key=lambda port_pin: port_pin[0])
			port_pin = merge_bus(port_pin);
		return port_pin;
	#------------------------------------
	pad_file = r'';
	for root, folders, files in os.walk(par_result):
		if '5_1.pad' in files:
			pad_file = os.path.join(root, '5_1.pad');
			package = get_package(pad_file);
			pad_list = get_port_pin(pad_file);
			return pad_list;
	return [];


#-----------------------------------------------main
top_save_dir = os.path.join(os.getcwd(), 'simrel_folder');
try:
	os.mkdir(top_save_dir);
except:
	pass;
run_main(work_dir,top_save_dir)
