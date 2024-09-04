import os
import sys
from .input import parser
from .tools import \
    (get_designs,
     start_check_flow,
     show_check_data_detail,
     get_final_status,
     create_check_report,
     show_check_data_simply
     )


def main(args=None):
    """ Entry point """
    if args is None:
        args = sys.argv[1:]
    args = parser.parse_args(args)

    os.environ["TOP_REAL_TAG"] = args.tag if args.tag else ""

    designs = get_designs(args)

    check_data_designs = start_check_flow(designs, args)

    if not check_data_designs:
        return 4, ('Case_Issue', None)

    final_status = get_final_status(check_data_designs, args)

    """
    if args.detail:
        show_check_data_detail(check_data_designs)
    else:
        show_check_data_simply(check_data_designs)
    """

    if not args.debug:
        create_check_report(check_data_designs, args)

    return final_status
