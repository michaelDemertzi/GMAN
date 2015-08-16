# -*- coding: utf-8 -*-
"""
Parse data csvs to aggregate states

Created on Wed Aug 05 18:54:01 2015

@author: Michael
"""
#import
import csv
import re

#zip code to ansi code concordance table
states = {'AL':1,
'AK':2,
'AZ':4,
'AR':5,
'CA':6,
'CO':8,
'CT':9,
'DE':10,
'DC':11,
'FL':12,
'GA':13,
'HI':15,
'ID':16,
'IL':17,
'IN':18,
'IA':19,
'KS':20,
'KY':21,
'LA':22,
'ME':23,
'MD':24,
'MA':25,
'MI':26,
'MN':27,
'MS':28,
'MO':29,
'MT':30,
'NE':31,
'NV':32,
'NH':33,
'NJ':34,
'NM':35,
'NY':36,
'NC':37,
'ND':38,
'OH':39,
'OK':40,
'OR':41,
'PA':42,
'RI':44,
'SC':45,
'SD':46,
'TN':47,
'TX':48,
'UT':49,
'VT':50,
'VA':51,
'WA':53,
'WV':54,
'WI':55,
'WY':56}

#create dictionary by state
out = {}

#read in CSV
with open('keystone.csv','rb') as f:
    reader = csv.reader(f)
    i= 0
    rowNum=0
    for row in reader:
        if rowNum == 0:
            header = row
        else:
            #print a few examples
            if i < 10:
                print re.search('[0-9]+',row[6]).group(0)
                print row[16]
                print ''
                i += 1
            '''    
            else:
                break
            '''
            #aggregate by state, store in dict
            
            try:
                #ERROR: REMOVES NEGATIVE CONTRIBUTIONS AND TREATS THEM AS POSITIVE!
                out[row[16]] += int(re.search('[0-9]+',row[6]).group(0))
            except:
                out[row[16]] = int(re.search('[0-9]+',row[6]).group(0))

        rowNum += 1

for key in out:
    print key,out[key]

#delete missing states values
del out['']

#write dict to csv
with open('aggregateCounties.csv', 'wb') as f:
    writer = csv.writer(f)
    writer.writerow(['id','dollar'])
    for key, value in out.items():
        writer.writerow([key, value])
        print [key, value]

