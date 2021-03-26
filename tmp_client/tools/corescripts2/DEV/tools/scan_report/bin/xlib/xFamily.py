qa_family = dict(
    ec     = ("ec",   "lattice"),
    ecp    = ("ecp",  "lattice"),
    ecp2   = ("ecp2", "lattice"),
    ecp2m  = ("ecp2","lattice"),
    ecp3   = ("ecp3", "lattice"),
    ecp4   = ("ecp4", "lattice"),
    sc     = ("sc",   "lattice"),
    scm    = ("sc",   "lattice"),
    xp     = ("xp",   "lattice"),
    xp2    = ("xp2",  "lattice"),
    xo     = ("xo",   "lattice"),
    xo2    = ("xo2",  "lattice"),
    sap    = ("sapphire", "lattice"),
    sapphire    = ("sapphire", "lattice"),

    max2     = ("max2",     "altera"),
    maxii    = ("max2",     "altera"),
    max5     = ("max5",     "altera"),
    maxv     = ("max5",     "altera"),
    stratix2 = ("stratix2", "altera"),
    stratix3 = ("stratix3", "altera"),
    stratix4 = ("stratix4", "altera"),
    stratix5 = ("stratix5", "altera"),
    stx2     = ("stratix2", "altera"),
    stx3     = ("stratix3", "altera"),
    stx4     = ("stratix4", "altera"),
    stx5     = ("stratix5", "altera"),
    arria2   = ("arria2",   "altera"),
    cyclone2 = ("cyclone2", "altera"),
    cyclone3 = ("cyclone3", "altera"),
    cyclone4 = ("cyclone4", "altera"),
    cyclone5 = ("cyclone5", "altera"),
    cy2      = ("cyclone2", "altera"),
    cy3      = ("cyclone3", "altera"),
    cy4      = ("cyclone4", "altera"),
    cy5      = ("cyclone5", "altera"),
    cyc2     = ("cyclone2", "altera"),
    cyc3     = ("cyclone3", "altera"),
    cyc4     = ("cyclone4", "altera"),
    cyc5     = ("cyclone5", "altera"),

    spartan3 = ("spartan3", "xilinx"),
    spartan6 = ("spartan6", "xilinx"),
    sp3      = ("spartan3", "xilinx"),
    sp6      = ("spartan6", "xilinx"),
    virtex4  = ("virtex4",  "xilinx"),
    virtex5  = ("virtex5",  "xilinx"),
    virtex6  = ("virtex6",  "xilinx"),
    v4       = ("virtex4",  "xilinx"),
    v5       = ("virtex5",  "xilinx"),
    v6       = ("virtex6",  "xilinx"),
    at7      = ("artix7",   "xilinx"),
    artix7   = ("artix7",   "xilinx"),

    ice      = ("ice",      "cube")
)

def get_std_family_vendor(raw_family):
    """
    Get standard family name and vendor name
    """
    std_family_vendor = ("", "")
    if raw_family:
        std_family_vendor = qa_family.get(raw_family.lower(), std_family_vendor)
    return std_family_vendor

def get_family_by_vendor(vendor=""):
    """
    get supported family list by vendor name
    get all supported family list if no vendor name specified
    """
    family_list = list()
    for key, value in qa_family.items():
        if not vendor:
            family_list.append(key)
        elif value[1] == vendor:
            family_list.append(key)
    family_list.sort()
    return family_list