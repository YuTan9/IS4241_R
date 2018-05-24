import requests
from xlrd import open_workbook
import xlwt

book = open_workbook('wutong.xlsx')
table = book.sheets()[1]
data_list=[]
data_list.extend(table.col_values(0)) # get all journals
nodes = set(data_list)   # remove duplicates
data_list = list(nodes)
edgelist = set()  # list for storing (from, to, weight) tuples
errorlist = set()

for i in range(0, len(data_list)):
    headers = {
    'Host': 'jcr.incites.thomsonreuters.com.libproxy1.nus.edu.sg',
    'Connection': 'keep-alive',
    'X-Requested-With': 'XMLHttpRequest',
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36',
    'Accept': '*/*',
    'Referer': 'http://jcr.incites.thomsonreuters.com.libproxy1.nus.edu.sg/JCRJournalProfileAction.action?',
    'Accept-Encoding': 'gzip, deflate',
    'Accept-Language': 'en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7,ja;q=0.6,ko;q=0.5',
    'Cookie': 'GA1.3.1232536728.1516339000; libproxy1=Fbz60kAxa7gUWc6; jcr.cb1=true; jcr.cb2=true; jcr.cb3=true; jcr.cb4=true; jcr.cb5=true; jcr.cb6=true; jcr.cb7=true; jcr.cb8=true; jcr.cb9=true; jcr.cb10=true; jcr.cb11=true; jcr.cb12=true; jcr.cb13=true; jcr.cb14=true; jcrvisualization=hide; jcr.minCapYearJCRtoWoS=1999; jcr.maxCapYearJCRtoWoS=2016; jcr.jcrToWoSenabled=yes; jcr.journalHomeStickOAFlag=N; jcr.journalHomeStickEdition=Both; jcr.journalHomeStickFullJournalTitles=MIS QUART; jcr.journalHomeStickPublishers=; jcr.journalHomeStickCountries=; jcr.journalHomeStickCats=; jcr.journalHomeStickJifQuartile=undefined; jcr.journalHomeStickCatScheme=WoS; jcr.journalHomeStickImpactFrom=null; jcr.journalHomeStickImpactTo=null; jcr.journalHomeStickAverageJifFrom=null; jcr.journalHomeStickAverageJifTo=null; jcr.journalHomeStickJCRYear=2016; jcr.abbrJournal=MIS%20QUART; jcr.journalEdition=SSCI; jcr.journalJcrYear=2016; jcr.breadCrumb=Home#./JCRJournalHomeAction.action?year=&edition=&journal=##Journal Profile(MIS QUARTERLY)#./JCRJournalProfileAction.action?pg=JRNLPROF&journalImpactFactor=7.268&journalTitle=MIS QUARTERLY&year=2016&edition=SSCI&journal=MIS QUART'
    }
    params = {
        'abbrJournal': data_list[i],
        'jcrYear': '2016',
        'edition': 'SSCI',
        'sort':'allYrs',
        'dir':'DESC'
    }

    # get all cited journals
    try: 
        result = requests.get('http://jcr.incites.thomsonreuters.com.libproxy1.nus.edu.sg/CitedJournalDataJson.action',
            headers=headers, params=params)
        allJournals = eval(result.content).get('data')
        maxNum = allJournals[0].get('allYrs')
        for journal in allJournals:
            if(journal.get('citingJournal') in data_list and float(journal.get('allYrs')) > (0.03 * float(maxNum))): # the journal is in the journals we have
                edgelist.add((journal.get('citingJournal'), data_list[i], journal.get('allYrs')))
    except: 
        errorlist.add(data_list[i])

    # get all citing journals
    try:
        result = requests.get('http://jcr.incites.thomsonreuters.com.libproxy1.nus.edu.sg/CitingJournalDataJson.action',
            headers=headers, params=params)
        allJournals = eval(result.content).get('data')
        maxNum = allJournals[0].get('allYrs')
        for journal in allJournals:
            if(journal.get('citedJournal') in data_list and float(journal.get('allYrs')) > (0.01 * float(maxNum))): # the journal is in the journals we have
                edgelist.add((data_list[i], journal.get('citedJournal'), journal.get('allYrs')))
    except: 
        errorlist.add(data_list[i])

print(len(edgelist))
print(len(errorlist))


# write into new excel file
newFile = xlwt.Workbook()
newTable = newFile.add_sheet('Alter_connection')

index = 0
for edge in edgelist:
    newTable.write(index, 0, edge[0])
    newTable.write(index, 1, edge[1])
    newTable.write(index, 2, edge[2]) # assign a random weight
    index += 1

errorTable = newFile.add_sheet('Error')
index = 0
for error in errorlist:
    errorTable.write(index, 0, error)
    index += 1 

newFile.save('Alter_connection_0.01.xls')
