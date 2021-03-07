
__author__ = 'syan'


def get_pool_list():
    pool_list=list()
    # pool_list.append("diamond/trunk/BE_11_IBIS               ")
    pool_list.append("DesignPool/trunk/QoR_suite/Generic_QoR")
    pool_list.append("diamond/trunk/BE_14_Preference         ")
    pool_list.append("diamond/trunk/BE_16_DSP_QoR            ")
    pool_list.append("diamond/trunk/BE_18_STA                ")
    pool_list.append("diamond/trunk/BE_19_MPAR               ")
    pool_list.append("diamond/trunk/BE_20_Backanno_simulation")
    pool_list.append("diamond/trunk/BE_22_Competitor_QoR     ")
    pool_list.append("diamond/trunk/FE_01_ORCAStra           ")
    pool_list.append("diamond/trunk/FE_02_IPExpressScuba     ")
    pool_list.append("diamond/trunk/FE_04_PMI                ")
    pool_list.append("diamond/trunk/FE_11_LSE                ")
    pool_list.append("diamond/trunk/FE_13_SynplifyPro        ")
    pool_list.append("diamond/trunk/FE_15_Simulator          ")
    # pool_list.append("diamond/trunk/FE_19_ReferenceDesign    ")
    # pool_list.append("diamond/trunk/FE_20_MicoSystem         ")
    # pool_list.append("diamond/trunk/FE_21_LSE_Ind            ")
    pool_list = [item.strip() for item in pool_list]

    return pool_list

if __name__ == "__main__":
    for item in get_pool_list():
        print item