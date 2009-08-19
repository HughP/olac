
# print header
print '<?xml version="1.0" encoding="UTF-8" ?> <collection xmlns="http://www.loc.gov/MARC21/slim"> <record>'

# control fields
# special 008
print '<leader>00981nam a22002658a 4500</leader> <controlfield tag="008">930503s1993    mau      b    000 0 eng  </controlfield>'

# 001-007
for tag in range(1,8):
    print '\t<controlfield ind1="" ind2="" tag="%03d">cf%03d' % (tag,tag)
    print '</controlfield>'

# 009
print '\t<controlfield ind1="" ind2="" tag="009">cf009</controlfield>'

# data fields
charRange = range(ord('a'),ord('z')+1)
for tag in range(10,1000):
    print '\t<datafield ind1="" ind2="" tag="%03d">' % tag
    for x in charRange:
        sub = chr(x)
        print '\t\t<subfield code="%s">%03d%s</subfield>' % (sub,tag,sub)
    print '\t</datafield>'

# print footer
print '</record> </collection>'
