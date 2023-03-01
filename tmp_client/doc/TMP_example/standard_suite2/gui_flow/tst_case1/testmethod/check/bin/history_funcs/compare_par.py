#!C:\Python27\python.exe
import os
import traceback
import re
import sys

class par_inform_list( object ):
    keys = [ 
        "LEVEL"            ,
        "NUMBER_UNROUTED"  ,
        "WORST_SLACK"      ,
        "TIMING_SCORE"     ,
        "WORST_SLACK_HOLD" ,
        "TIMING_SCORE_HOLD",
        "RUN_TIME"         ,
        "NCD_STATUS"       
    ]

    def __init__( self,WS='ws' ):
        self.inf_list = []
        if WS.lower().find('ts') != -1:
            WS = False
        else:
            WS = True
        self.ws = WS
    
    
    def compare(self, initial_line,cmp_line):
        '''
            if retrun is -1, the program will change the initial_line and cmp_line
        '''
        last_mode_ws = True
        last_mode_ws = self.ws
        if initial_line[-1] != cmp_line[-1]:
            if cmp_line[-1] == 'completed':
                #print 'in 1'
                return -1
            else:
                return 0;
        if int(initial_line[1]) > int(cmp_line[1]):
            #print 'in 2'
            return -1
        elif int(initial_line[1]) < int(cmp_line[1]):
            return 0
        if 1: # this is the thrid step
            if (initial_line[3], cmp_line[3]) == ('0','0') and ( initial_line[5] == '0' and cmp_line[5] == '0' ):
                #if last_mode_ws:
                    if float(cmp_line[2]) > float(initial_line[2]):
                        #print 'in 3'
                        return -1
                    elif float(cmp_line[2]) < float(initial_line[2]):
                        return 0
                    try:
                        n1 = (cmp_line[0]).split('_')[1]
                        n2 = (initial_line[0]).split('_')[1]
                        if int(n1) < int(n2):
                            #print 'in 4'
                            return -1
                        else:
                            return 0
                    except:
                        return 0
            elif (cmp_line[5], cmp_line[3]) == ('0','0') and ( initial_line[5] != '0' or initial_line[3] != '0' ):
                return -1
            elif (initial_line[5], initial_line[3]) == ('0','0') and ( cmp_line[5] != '0' or cmp_line[3] != '0' ):
                return 0
                    
            else:
                if last_mode_ws:
                    if float(cmp_line[2]) > float(initial_line[2]):
                        #print 'in 5'
                        return -1
                    elif float(cmp_line[2]) < float(initial_line[2]):
                        
                        return 0
                    if int(cmp_line[3]) < int(initial_line[3]):
                        #print 'in 6'
                        return -1
                    elif int(cmp_line[3]) > int(initial_line[3]):
                        return 0
                    try:
                        n1 = (cmp_line[0]).split('_')[1]
                        n2 = (initial_line[0]).split('_')[1]
                        if int(n1) < int(n2):
                            #print 'in 7'
                            return -1
                        else:
                            return  0
                    except:
                        return 0
                else:
                
                    if int(cmp_line[3]) < int(initial_line[3]):
                        #print 'in 8'
                        return -1
                    elif int(cmp_line[3]) > int(initial_line[3]):
                        
                        return 0
                        
                    if float(cmp_line[2]) > float(initial_line[2]):
                        #print 'in 9'
                        return -1
                    elif float(cmp_line[2]) < float(initial_line[2]):
                        
                        return 0
                    try:
                        n1 = (cmp_line[0]).split('_')[1]
                        n2 = (initial_line[0]).split('_')[1]
                        if int(n1) < int(n2):
                            #print 'in 10'
                            return -1
                        else:
                            return 0
                    except:
                        return 0
                    
        return 0       
        
    def compare2( self, line, cmp_line ):
        last_mode_ws = True
        last_mode_ws = self.ws
        if not line[-1] == cmp_line[-1]:
            # print -1 if line[-1] == 'completed' else 1
            # return -1 if line[-1] == 'completed' else 1
            if line[-1] == 'completed':
                t = -1
            else:
                t = 1
            print(t)
            return t
        elif not line[1] == cmp_line[1]:
            # print -1 if cmp_line[1] == '-' or int(line[1]) < int(cmp_line[1]) else 1
            # return -1 if cmp_line[1] == '-' or int(line[1]) < int(cmp_line[1]) else 1
            if cmp_line[1] == '-':
                t = -1
            elif int(line[1]) < int(cmp_line[1]):
                t = -1
            else:
                t = 1
            print(t)
            return t
            
        elif (line[3], cmp_line[3]) == ('0','0') and ( line[5] == '0' and cmp_line[5] == '0' ):
            if float(line[2]) < float(cmp_line[2]):
                print(float(line[2]))
               
                print(cmp_line[2])
                print('HAHAHA')
                print('cmp_line',cmp_line)
                print(line)
                return -1
            try:
                n1 = line[0].split('_')[1]
                n2 = cmp_line[0].split('_')[1]
                if int(n1) < int(n2):
                    return -1
            except:
                pass
            
            '''
            This is the old one
            elif (line[3], cmp_line[3]) == ('0','0') and ( line[5] == '0' or cmp_line[5] == '0' ):
                if not ( line[5] == '0' and cmp_line[5] == '0' ):
                    # print "ONE_0_TSH"
                    print -1 if line[5] == '0' else 1
                    return -1 if line[5] == '0' else 1 '''
        else:
            #print "ONE_NOT_0_TS"
            last_mode_ws = self.ws

        if last_mode_ws:
            # print "WS"
            if line[2] == cmp_line[2]:
                return 0
            else:
                # print  -1 if cmp_line[2] == '-' or float(line[2]) > float(cmp_line[2]) else 1
                # return -1 if cmp_line[2] == '-' or float(line[2]) > float(cmp_line[2]) else 1
                if cmp_line[2] == '-':
                    t = -1
                elif float(line[2]) > float(cmp_line[2]):
                    t = -1
                else:
                    t = 1
                print(t)
                return t
        else:
            # print "TS"
            if line[3] == cmp_line[3]:
                return 0
            else:
                # print  -1 if cmp_line[3] == '-' or int(line[3]) < int(cmp_line[3]) else 1
                # return -1 if cmp_line[3] == '-' or int(line[3]) < int(cmp_line[3]) else 1
                if cmp_line[3] == '-':
                    t = -1
                elif int(line[3]) < int(cmp_line[3]):
                    t = -1
                else:
                    t = 1
                print(t)
                return t

    def sort( self, list_to_sort ):
        result_list = []
        result_list.extend( list_to_sort )
        for i in range( len(result_list) ):
            index_min = i
            for j in range( i+1, len(result_list) ):
                if self.compare(  result_list[index_min], result_list[j]) < 0:
                    #print 'initial:',result_list[index_min]
                    #print 'compare:',result_list[j]
                    #raw_input()
                    index_min = j
            if not index_min == i:
                result_list[index_min], result_list[i] = result_list[i], result_list[index_min]
        return result_list

    def check_sequence( self ):
        list_sorted = self.sort( self.inf_list )
        print('--------------------')
        print('init:'," ".join( item[0] for item in self.inf_list))
        print('Sorted:'," ".join( item[0] for item in list_sorted))
        print('--------------------')
        for i in range( len(self.inf_list) ):
            #print self.inf_list[i][0]
            #print list_sorted[i][0]
            if not self.inf_list[i][0] == list_sorted[i][0]:
                
                return 'Fail'
        return 'True'

    def get_item_indexes( self, start_line ):
        start_line = start_line.rstrip( "\n" ) + " "
        result_list = []
        index = -1
        for i in range( len(start_line) ):
            if index >= 0:
                if start_line[i] == " ":
                    result_list.append( index )
                    index = -1
            else:
                if start_line[i] == "-":
                    index = i
        if len(result_list) == len(par_inform_list.keys):
            self.item_indexes = result_list
            return 0
        else:
            return -1

    def get_line( self, str_line ):
        str_line = str_line.rstrip( "\n" ) + " "
        result_list = []
        #print self.item_indexes
        #raw_input(1)
        for i in self.item_indexes:
            if not str_line[i] == " ":
                 result_list.append( str_line[ i : str_line.index( " ", i ) ] )
            else:
                 result_list.append( "-" )
        self.inf_list.append( result_list )
        #print self.inf_list
        #raw_input(2)

    def get_list( self, path ):
        try:
            f = open( path, "r" )
            got_start = False
            l = f.readline()
            while not l == "":
                if got_start:
                    if not l == "\n":
                        self.get_line( l.lower() )
                    else:
                        break;
                elif l == "\n":
                    l = f.readline()
                    if l.startswith( "Level" ):
                        l = f.readline()
                        ln = f.readline()
                        if l.startswith( "Cost" ) and ln.startswith( "-" ):
                            if self.get_item_indexes( ln ) >= 0:
                                got_start = True        
                            else:
                                print("Failed to catch items: Items' amount doesn't match.")
                                return -1
                l = f.readline()

            f.close()            
            return 0

        except IOError as e:
            print("Failed in reading par file: " + e)
            return -1
            
def run(dir,mode):
    if os.path.isdir(dir):
        pass
    else:
        return ['False','Can not get %s'%dir]
    return_list = ['True','']
    for root1,dir1,fs in os.walk( os.getcwd() ):
        for f in fs:
            if f.endswith('.par'):
                inf = par_inform_list(mode)
                par_file = os.path.join(root1,f)
                inf.get_list( par_file )
                if inf.check_sequence() == 'Fail':
                    return ['Fail',par_file]
    return return_list

if __name__ == '__main__':
    #print run(r'C:\Users\yzhao1\Desktop\debug\Desktop\DDR2_design\_scratch/impl','ws')
    #raw_input()
    try:
        model = sys.argv[1]
    except Exception:
        model = ''
    if model:
        ws = True
    else:
        ws = False
    for root1,dir1,fs in os.walk(os.getcwd()):
        
        for f in fs:
            if f.endswith('.par'):
                inf = par_inform_list(ws)
                par_file = os.path.join(root1,f)
                inf.get_list( par_file )
                #print par_file
                #print inf.check_sequence()
                #raw_input()