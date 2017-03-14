# ****************************************************************************
# Training set 1- a2g.input contains only values beginning with the letters A-G
# Training set 2- h2z.input contains only values beginning with the letters H-Z
# Test values- a2z.test.data contains sample values from both training sets, 
#             plus a value not in either training set
#
#                      Expected Value          Expected Value
#   Test Value      After 1st training set  After 2nd training set
# ----------------  ----------------------  ----------------------  
# 1 | Adventure      Non-Zero Real Value     Non-Zero Real Value
# 1 | Fun            Non-Zero Real Value     Non-Zero Real Value
# 1 | Dutch_Ovens    Non-Zero Real Value     Non-Zero Real Value
# 1 | NOT_IN_INPUT            0                       0
# 1 | Helpful                 0              Non-Zero Real Value
# 1 | Outdoors                0              Non-Zero Real Value
# 1 | Values                  0              Non-Zero Real Value
# ****************************************************************************

# start clean
rm -f a2?.model temp.cache a2?.test.out

# train on words starting with A-G
vw --data a2g.input --loss_function squared -k --cache_file=temp.cache --final_regressor a2g.model --save_resume &> /dev/null

# test on words starting with A-Z
vw --testonly --audit --initial_regressor a2g.model --data a2z.test.data > a2g.test.out 2> /dev/null

# additional training on words H-Z
vw --initial_regressor a2g.model --data h2z.input --loss_function squared -k --cache_file=temp.cache --final_regressor a2z.model --save_resume &> /dev/null

# test on words staring with A-Z
vw --testonly --audit --initial_regressor a2z.model --data a2z.test.data > a2z.test.out 2> /dev/null

# check against expected results
A2G_FAILED=true
A2G_MESSAGE="a2g test failed"
if cmp -s a2g.test.out a2g.test.expected.out 
then
    A2G_FAILED=false
    A2G_MESSAGE="a2g output file matches"
fi

A2Z_FAILED=true
A2Z_MESSAGE="a2z test failed"
if cmp -s a2z.test.out a2z.test.expected.out 
then
    A2Z_FAILED=false
    A2Z_MESSAGE="a2z output file matches"
fi

if "$A2G_FAILED" || "$A2Z_FAILED"
then
    echo "VW CRITICAL - $A2G_MESSAGE -- $A2Z_MESSAGE"
    exit $STATE_CRITICAL
else
    echo "VW OK - $A2G_MESSAGE -- $A2Z_MESSAGE"
    exit $STATE_OK
fi

# assuming things are weird if we get here...
exit $STATE_UNKNOWN
