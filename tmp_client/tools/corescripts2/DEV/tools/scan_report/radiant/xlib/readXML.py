from xml.etree import ElementTree

__author__ = 'syan'

def print_node(node, blank=""):
    for key, value in node.items():
        print "%s %s:%s" % (blank, key, value)
    more_blanks = blank + "    "
    for sub_node in node.getchildren():
        print more_blanks,  sub_node.tag
        print_node(sub_node, more_blanks)

def print_xml(text='', xml_file=''):
    if xml_file:
        root = ElementTree.parse(xml_file)
    elif text:
        root = ElementTree.fromstring(text)
    else:
        my_log = "Can not parse the XML file or string."
        raise my_log
    my_iterator = root.getiterator("BaliProject")
    for e in my_iterator:
        print e.tag
        print_node(e, "    ")

def old_parse_ldf_file(ldf_file="", ldf_lines=""):
    """
    source
    [{'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/I2C_SLAVE/I2cGpios_Top.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/I2C_SLAVE/i2c_slave_gpio.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/I2C_SLAVE/bounce.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/ImageData_CH/TOP_CH.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/ImageData_CH/main_path_data.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/ImageData_CH/line_buffer_ctr.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/RD1146_ECP5/CSI2_PLL.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/RD1146_ECP5/deser.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/RD1146_ECP5/gearing_converter_fifo.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/RD1146_ECP5/hwidth_reducer.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/RD1146_ECP5/MIPI_CSI2_Serial2Parallel.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/RD1146_ECP5/MIPI_CSI2_Serial2Parallel_Bridge.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/RD1146_ECP5/parser.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/NGO_Source_Lattice_Confidential/control_capture_lane2.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/NGO_Source_Lattice_Confidential/lane_aligner.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/NGO_Source_Lattice_Confidential/raw10_lane2.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/NGO_Source_Lattice_Confidential/word_aligner.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/NGO_Source_Lattice_Confidential/ECP5_clairty/lane_align_FIFO/lane_align_FIFO.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/NGO_Source_Lattice_Confidential/ECP5_clairty/raw10_lane2_fifo/raw10_lane2_fifo.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/top_C2.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/TestBench/DetectSignal.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/ImageData_CH/DlySync.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/RD1146_ECP5/PLL_PCK.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/RD1146_ECP5/LineBuffer_fifo.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/ImageData_CH/colorbar_gen.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/ImageData_CH/colorbar_gen_964X544.v', 'excluded': 'TRUE', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/ImageData_CH/line_buffer_data.v', 'excluded': 'TRUE', 'type_short': 'Verilog'}, {'type': 'Logic Preference', 'name': 'MIPI_Rx_C2.lpf', 'type_short': 'LPF'}, {'type': 'Programming Project File', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2/MIPI_Bady.xcf', 'type_short': 'Programming'}, {'type': 'Reveal', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2/MIPI_Bady_MIPI_Rx_C2.rvl', 'excluded': 'TRUE', 'type_short': 'Reveal'}, {'type': 'Reveal Analyzer Project File', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2/MIPI_Rx_C2.rva', 'type_short': 'RVA'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/I2cGpios_Top.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/i2c_slave_gpio.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/bounce.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/TOP_CH.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/main_path_data.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/line_buffer_ctr.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/CSI2_PLL.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/deser.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/gearing_converter_fifo.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/hwidth_reducer.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/MIPI_CSI2_Serial2Parallel.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/MIPI_CSI2_Serial2Parallel_Bridge.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/parser.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/control_capture_lane2.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/lane_aligner.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/raw10_lane2.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/word_aligner.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/lane_align_FIFO.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/raw10_lane2_fifo.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/top_C2.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/DetectSignal.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/DlySync.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/PLL_PCK.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/LineBuffer_fifo.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/colorbar_gen.v', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/colorbar_gen_964X544.v', 'excluded': 'TRUE', 'type_short': 'Verilog'}, {'type': 'Verilog', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/line_buffer_data.v', 'excluded': 'TRUE', 'type_short': 'Verilog'}, {'type': 'Logic Preference', 'name': 'MIPI_Rx_C2.lpf', 'type_short': 'LPF'}, {'type': 'LSE Design Constraints File', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE.ldc', 'type_short': 'LDC'}, {'type': 'Programming Project File', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/MIPI_Bady.xcf', 'type_short': 'Programming'}, {'type': 'Reveal', 'name': '../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/MIPI_Bady_MIPI_Rx_C2.rvl', 'excluded': 'TRUE', 'type_short': 'Reveal'}]

    impl
    {'description': 'MIPI_Rx_C2', 'title': 'MIPI_Rx_C2', 'default_strategy': 'Strategy1', 'dir': 'MIPI_Rx_C2', 'synthesis': 'synplify'}

    bali
    {'device': 'LFE5UM-85F-8MG285CES', 'default_implementation': 'MIPI_Rx_C2_LSE', 'version': '3.2', 'title': 'MIPI_Bady'}
    """
    if ldf_file:
        root = ElementTree.parse(ldf_file)
    else:
        root = ElementTree.fromstring(ldf_lines)
    ldf_dict = dict()

    def get_node(node_name):
        node = root.getiterator(node_name)
        if not node:
            print("-Error. Not found node %s in %s" % (node_name, ldf_file))
            return ""
        return node

    # BaliProject
    bali_node = get_node("BaliProject")
    if bali_node:
        ldf_dict["bali"] = bali_node[0].attrib

    # Implementation
    impl_node = get_node("Implementation")
    if impl_node:
        ldf_dict["impl"] = impl_node[0].attrib
    # Source
    src_node = get_node("Source")
    if src_node:
        src_list = list()
        for child in src_node:
            src_list.append(child.attrib)
        ldf_dict["source"] = src_list
    return ldf_dict

def dump2dict(a_node):
    t = dict()
    for key, value in a_node.items():
        t[key] = value
    return t

def parse_ldf_file(ldf_file="", ldf_lines="", for_radiant=""):
    if ldf_file:
        root = ElementTree.parse(ldf_file)
    else:
        root = ElementTree.fromstring(ldf_lines)
    tag = "RadiantProject" if for_radiant else "BaliProject"
    my_iterator = root.getiterator(tag)
    bali_node = None
    for e in my_iterator:
        if e.tag == tag:
            bali_node = e
            break
    ldf_dict = dict()
    if bali_node is None:
        return ldf_dict
    # bali
    bali_dict = dump2dict(bali_node)
    ldf_dict["bali"] = bali_dict

    # impl & source
    src_list = list()
    def_impl_name = ""
    for key, value in bali_node.items():
        if key == "default_implementation":
            def_impl_name = value

    for sub_node in bali_node.getchildren():
        tag_name = sub_node.tag
        if tag_name == "Implementation":
            impl_dict = dump2dict(sub_node)
            impl_title = impl_dict.get("title")
            if impl_title == def_impl_name:
                ldf_dict["impl"] = impl_dict
                for src_node in sub_node.getchildren():
                    if src_node.tag == "Source":
                        src_list.append(dump2dict(src_node))
    ldf_dict["source"] = src_list
    return ldf_dict

if __name__ == "__main__":
    xml_string = """<?xml version="1.0" encoding="UTF-8"?>
<BaliProject version="3.2" title="MIPI_Bady" device="LFE5UM-85F-8MG285CES" default_implementation="MIPI_Rx_C2_LSE">
    <Options>
        <Option name="HDL type" value="Verilog"/>
    </Options>
    <Implementation title="MIPI_Rx_C2" dir="MIPI_Rx_C2" description="MIPI_Rx_C2" synthesis="synplify" default_strategy="Strategy1">
        <Options>
            <Option name="HDL type" value="Verilog"/>
            <Option name="def_top" value="DetectSignal"/>
            <Option name="lib" value="work"/>
            <Option name="top" value="top_C2"/>
        </Options>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/I2C_SLAVE/I2cGpios_Top.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/I2C_SLAVE/i2c_slave_gpio.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/I2C_SLAVE/bounce.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/ImageData_CH/TOP_CH.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/ImageData_CH/main_path_data.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/ImageData_CH/line_buffer_ctr.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/RD1146_ECP5/CSI2_PLL.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/RD1146_ECP5/deser.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/RD1146_ECP5/gearing_converter_fifo.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/RD1146_ECP5/hwidth_reducer.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/RD1146_ECP5/MIPI_CSI2_Serial2Parallel.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/RD1146_ECP5/MIPI_CSI2_Serial2Parallel_Bridge.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/RD1146_ECP5/parser.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/NGO_Source_Lattice_Confidential/control_capture_lane2.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/NGO_Source_Lattice_Confidential/lane_aligner.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/NGO_Source_Lattice_Confidential/raw10_lane2.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/NGO_Source_Lattice_Confidential/word_aligner.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/NGO_Source_Lattice_Confidential/ECP5_clairty/lane_align_FIFO/lane_align_FIFO.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/NGO_Source_Lattice_Confidential/ECP5_clairty/raw10_lane2_fifo/raw10_lane2_fifo.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/top_C2.v" type="Verilog" type_short="Verilog">
            <Options top_module="top_C2"/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/TestBench/DetectSignal.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/ImageData_CH/DlySync.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/RD1146_ECP5/PLL_PCK.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/RD1146_ECP5/LineBuffer_fifo.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/ImageData_CH/colorbar_gen.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/ImageData_CH/colorbar_gen_964X544.v" type="Verilog" type_short="Verilog" excluded="TRUE">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/remote_files/sources/Simulation/Quant_MIPI/MIPI_Bady/src/ImageData_CH/line_buffer_data.v" type="Verilog" type_short="Verilog" excluded="TRUE">
            <Options/>
        </Source>
        <Source name="MIPI_Rx_C2.lpf" type="Logic Preference" type_short="LPF">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2/MIPI_Bady.xcf" type="Programming Project File" type_short="Programming">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2/MIPI_Bady_MIPI_Rx_C2.rvl" type="Reveal" type_short="Reveal" excluded="TRUE">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2/MIPI_Rx_C2.rva" type="Reveal Analyzer Project File" type_short="RVA">
            <Options/>
        </Source>
    </Implementation>
    <Implementation title="MIPI_Rx_C2_LSE" dir="MIPI_Rx_C2_LSE" description="MIPI_Rx_C2_LSE" synthesis="lse" default_strategy="Strategy1">
        <Options>
            <Option name="HDL type" value="Verilog"/>
            <Option name="def_top" value="DetectSignal"/>
            <Option name="lib" value="work"/>
            <Option name="top" value="top_C2"/>
        </Options>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/I2cGpios_Top.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/i2c_slave_gpio.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/bounce.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/TOP_CH.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/main_path_data.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/line_buffer_ctr.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/CSI2_PLL.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/deser.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/gearing_converter_fifo.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/hwidth_reducer.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/MIPI_CSI2_Serial2Parallel.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/MIPI_CSI2_Serial2Parallel_Bridge.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/parser.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/control_capture_lane2.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/lane_aligner.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/raw10_lane2.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/word_aligner.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/lane_align_FIFO.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/raw10_lane2_fifo.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/top_C2.v" type="Verilog" type_short="Verilog">
            <Options top_module="top_C2"/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/DetectSignal.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/DlySync.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/PLL_PCK.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/LineBuffer_fifo.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/colorbar_gen.v" type="Verilog" type_short="Verilog">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/colorbar_gen_964X544.v" type="Verilog" type_short="Verilog" excluded="TRUE">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/source/line_buffer_data.v" type="Verilog" type_short="Verilog" excluded="TRUE">
            <Options/>
        </Source>
        <Source name="MIPI_Rx_C2.lpf" type="Logic Preference" type_short="LPF">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE.ldc" type="LSE Design Constraints File" type_short="LDC">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/MIPI_Bady.xcf" type="Programming Project File" type_short="Programming">
            <Options/>
        </Source>
        <Source name="../project_l/Diamondproject/MIPI_Bady_1224_intemediate/MIPI_Bady_1224_GOLD/MIPI_Rx_C2_LSE/MIPI_Bady_MIPI_Rx_C2.rvl" type="Reveal" type_short="Reveal" excluded="TRUE">
            <Options/>
        </Source>
    </Implementation>
    <Strategy name="Strategy1" file="MIPI_Bady1.sty"/>
</BaliProject>
        """
    # print_xml(xml_string)

    my_ldf_dict_1 = parse_ldf_file(ldf_lines=xml_string)
    my_ldf_dict_2 = old_parse_ldf_file(ldf_lines=xml_string)
    for d in (my_ldf_dict_1, my_ldf_dict_2):
        for k, v in d.items():
            if k != "source":
                continue
            print k
            for m in v:
                print m
            print
        print "-" * 10