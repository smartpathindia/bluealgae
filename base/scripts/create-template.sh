TOPDIR=$1
PRODUCT=$2
if [ $# -lt 2 ]; then
echo "too less arguments"
echo "usage: $0 <TOPDIR> <product name>"
exit 1
fi
. ${TOPDIR}/products/${PPRODUCT}.txt
mkdir -p $TOPDIR/base/template/$PRODUCTNAME/fs
mkdir -p $TOPDIR/base/template/$PRODUCTNAME/tmpfs/var
mkdir -p $TOPDIR/base/template/$PRODUCTNAME/tmpfs/tmp
mkdir -p $TOPDIR/base/template/$PRODUCTNAME/$PRODUCTVERSION/fs
mkdir -p $TOPDIR/base/template/$PRODUCTNAME/$PRODUCTVERSION/tmpfs/var
mkdir -p $TOPDIR/base/template/$PRODUCTNAME/$PRODUCTVERSION/tmpfs/tmp

