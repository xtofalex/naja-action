from os import path
from enum import Enum
import sys
import logging
import glob
import argparse
import time

from najaeda import netlist
from najaeda import instance_visitor
from najaeda import stats

class PrimitivesMode(Enum):
    XILINX = "xilinx"
    LIBERTY = "liberty"

def enum_type(enum_class):
    def parse(s):
        try:
            return enum_class(s.lower())
        except ValueError:
            raise argparse.ArgumentTypeError(f"Invalid choice: {s}. Choose from {[e.value for e in enum_class]}")
    return parse

parser = argparse.ArgumentParser()
parser.add_argument(
    "--primitives_mode",
    required=True,
    type=enum_type(PrimitivesMode),
    help="Primitives mode: xilinx (FPGA) or liberty"
)
parser.add_argument("--liberty", type=str,
                    help="Path to the liberty file")
parser.add_argument("--verilog", type=str,
                    help="Path to the Verilog file")
args = parser.parse_args()

logging.basicConfig(level=logging.INFO)

if args.primitives_mode == PrimitivesMode.XILINX:
    logging.info("Using Xilinx primitives")
    netlist.load_primitives('xilinx')
elif args.primitives_mode == PrimitivesMode.LIBERTY:
    logging.info("Using Liberty primitives from: %s", args.liberty)
    if not args.liberty:
        logging.error("Liberty file must be specified when using liberty primitives mode.")
        exit(1)
    if not path.exists(args.liberty):
        logging.error(f"Liberty file does not exist: {args.liberty}")
        exit(1)
    #if args.liberty contains * then we expand it
    # Expand wildcard if present
    if '*' in args.liberty:
        logging.info(f"Expanding liberty file pattern: {args.liberty}")
        liberty_files = glob.glob(args.liberty)
        logging.info(f"Matched liberty files: {liberty_files}")
        if not liberty_files:
            logging.error(f"No liberty files matched the pattern: {args.liberty}")
            exit(1)
    else:
        liberty_files = [args.liberty]
    netlist.load_liberty(liberty_files)

top = netlist.load_verilog([args.verilog])

def count_leaves(instance, leaves):
    if instance.is_leaf():
        if instance.is_assign():
            leaves["assigns"] += 1
        elif instance.is_const():
            leaves["constants"] += 1
        else:
            leaves["count"] += 1

#count time to visit
start_visit_time = time.time()
leaves = {"count": 0, "assigns": 0, "constants": 0}
visitor_config = instance_visitor.VisitorConfig(callback=count_leaves, args=(leaves,))
instance_visitor.visit(top, visitor_config)
logging.info(f"{top} leaves count")
logging.info(f"nb_assigns={leaves['assigns']}")
logging.info(f"nb constants={leaves['constants']}")
logging.info(f"nb other leaves={leaves['count']}")
end_visit_time = time.time()
logging.info(f"Time taken to visit design: {end_visit_time - start_visit_time} seconds")

# Dump design stats
logging.info("Dumping design stats")
design_stats_file = open('design.stats', 'w')
stats.dump_instance_stats_text(top, design_stats_file)
design_stats_file.close()
logging.info("Design stats dumped to design.stats")

sys.exit(0)