from os import path
import sys
import logging
import glob
import argparse

from najaeda import netlist
from najaeda import instance_visitor

parser = argparse.ArgumentParser(description="Count leaf instances in a netlist.")
parser.add_argument("--liberty", type=str,
                    help="Path to the liberty file")
parser.add_argument("--verilog", type=str,
                    help="Path to the Verilog file")
args = parser.parse_args()

logging.basicConfig(level=logging.INFO)

#if args.liberty contains * then we expand it

# Expand wildcard if present
if '*' in args.liberty:
    liberty_files = glob.glob(args.liberty)
    if not liberty_files:
        logging.error(f"No liberty files matched the pattern: {args.liberty}")
        exit(1)
else:
    liberty_files = [args.liberty]

netlist.load_liberty(liberty_files)
top = netlist.load_verilog([args.verilog])

leaves = {"count": 0, "assigns": 0, "constants": 0}
def count_leaves(instance, leaves):
    if instance.is_leaf():
        if instance.is_assign():
            leaves["assigns"] += 1
        elif instance.is_const():
            leaves["constants"] += 1
        else:
            leaves["count"] += 1
visitor_config = instance_visitor.VisitorConfig(callback=count_leaves, args=(leaves,))
instance_visitor.visit(top, visitor_config)
print(f"{top} leaves count")
print(f"nb_assigns={leaves['assigns']}")
print(f"nb constants={leaves['constants']}")
print(f"nb other leaves={leaves['count']}")

design_stats_file = open('design.stats', 'w')
stats.dump_instance_stats_text(top, design_stats_file)

sys.exit(0)