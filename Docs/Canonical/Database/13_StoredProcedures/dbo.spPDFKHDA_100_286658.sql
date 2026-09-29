SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spPDFKHDA_100_286658]                   
                  
AS

SET NOCOUNT ON   
/*
Copiar arquivos de processos encerrados para entrega ao cliente Dow - Exportações 2020

Criar pasta na rede com as cópias dos documentos disponíveis nos jobs listados no arquivo anexo.

Obs.: Será necessário criar uma pasta por processo e deverão ser nomeadas com a informação de PO Number (segunda coluna do relatório)
*/

create table #tmp_num_proc_num_po           
(          
      num_proc		varchar(16) COLLATE Latin1_General_CI_AI    
	  ,numero_po	varchar(60) COLLATE Latin1_General_CI_AI     
)             
         
if 1 = 1         
begin        
	insert into #tmp_num_proc_num_po select  'EACSR202001002BR','1105MM'
	insert into #tmp_num_proc_num_po select  'EACSR202002001BR','4004990464'
	insert into #tmp_num_proc_num_po select  'EACSR202004001BR','111067469'
	insert into #tmp_num_proc_num_po select  'EACSR202005002BR','0110741330'
	insert into #tmp_num_proc_num_po select  'EACSR202009002BR','0382LV'
	insert into #tmp_num_proc_num_po select  'EACSR202010004BR','4005576038'
	insert into #tmp_num_proc_num_po select  'EACSR202101002BR','4005677568'
	insert into #tmp_num_proc_num_po select  'EMCSR201911077BR','4004775448'
	insert into #tmp_num_proc_num_po select  'EMCSR201911102BR','4004750268'
	insert into #tmp_num_proc_num_po select  'EMCSR201912003BR','0110540913'
	insert into #tmp_num_proc_num_po select  'EMCSR201912004BR','4004800498'
	insert into #tmp_num_proc_num_po select  'EMCSR201912005BR','4004800992'
	insert into #tmp_num_proc_num_po select  'EMCSR201912009BR','4004827988'
	insert into #tmp_num_proc_num_po select  'EMCSR201912010BR','0150687582'
	insert into #tmp_num_proc_num_po select  'EMCSR201912018BR','4004800998'
	insert into #tmp_num_proc_num_po select  'EMCSR201912019BR','4004831643'
	insert into #tmp_num_proc_num_po select  'EMCSR201912025BR','4004741609'
	insert into #tmp_num_proc_num_po select  'EMCSR201912035BR','4004721744'
	insert into #tmp_num_proc_num_po select  'EMCSR201912038BR','4004818776'
	insert into #tmp_num_proc_num_po select  'EMCSR201912039BR','4004801191'
	insert into #tmp_num_proc_num_po select  'EMCSR201912047BR','4004759902'
	insert into #tmp_num_proc_num_po select  'EMCSR201912048BR','4004759901'
	insert into #tmp_num_proc_num_po select  'EMCSR201912049BR','4004759894'
	insert into #tmp_num_proc_num_po select  'EMCSR201912051BR','4004759905'
	insert into #tmp_num_proc_num_po select  'EMCSR201912062BR','0150693855'
	insert into #tmp_num_proc_num_po select  'EMCSR201912068BR','4004787564'
	insert into #tmp_num_proc_num_po select  'EMCSR201912073BR','4004795800'
	insert into #tmp_num_proc_num_po select  'EMCSR201912078BR','4004832294'
	insert into #tmp_num_proc_num_po select  'EMCSR201912080BR','4004882810'
	insert into #tmp_num_proc_num_po select  'EMCSR201912085BR','4004845068'
	insert into #tmp_num_proc_num_po select  'EMCSR201912086BR','4004883752'
	insert into #tmp_num_proc_num_po select  'EMCSR201912087BR','4004883754'
	insert into #tmp_num_proc_num_po select  'EMCSR202001001BR','4004887057'
	insert into #tmp_num_proc_num_po select  'EMCSR202001011BR','4004822353'
	insert into #tmp_num_proc_num_po select  'EMCSR202001012BR','4004832232'
	insert into #tmp_num_proc_num_po select  'EMCSR202001016BR','4004822587'
	insert into #tmp_num_proc_num_po select  'EMCSR202001019BR','4004822594'
	insert into #tmp_num_proc_num_po select  'EMCSR202001020BR','4004822595'
	insert into #tmp_num_proc_num_po select  'EMCSR202001021BR','4004889037'
	insert into #tmp_num_proc_num_po select  'EMCSR202001024BR','4004787565'
	insert into #tmp_num_proc_num_po select  'EMCSR202001026BR','4004889014'
	insert into #tmp_num_proc_num_po select  'EMCSR202001029BR','4004868846'
	insert into #tmp_num_proc_num_po select  'EMCSR202001040BR','4004873691'
	insert into #tmp_num_proc_num_po select  'EMCSR202001044BR','4004794088'
	insert into #tmp_num_proc_num_po select  'EMCSR202001049BR','0150693876'
	insert into #tmp_num_proc_num_po select  'EMCSR202001052BR','4004917111'
	insert into #tmp_num_proc_num_po select  'EMCSR202001059BR','4004914289'
	insert into #tmp_num_proc_num_po select  'EMCSR202001064BR','110546351'
	insert into #tmp_num_proc_num_po select  'EMCSR202001067BR','4004843510'
	insert into #tmp_num_proc_num_po select  'EMCSR202001070BR','4004929869'
	insert into #tmp_num_proc_num_po select  'EMCSR202001071BR','4004926506'
	insert into #tmp_num_proc_num_po select  'EMCSR202001077BR','4004843513'
	insert into #tmp_num_proc_num_po select  'EACSR202003002BR','1156MM'
	insert into #tmp_num_proc_num_po select  'EACSR202003004BR','00750EN'
	insert into #tmp_num_proc_num_po select  'EACSR202004002BR','00822EN'
	insert into #tmp_num_proc_num_po select  'EACSR202005003BR','0110741330-2'
	insert into #tmp_num_proc_num_po select  'EACSR202008001BR','AM20200713SNF'
	insert into #tmp_num_proc_num_po select  'EACSR202009001BR','0382LV'
	insert into #tmp_num_proc_num_po select  'EACSR202009003BR','0111513279'
	insert into #tmp_num_proc_num_po select  'EMCSR201911080BR','4004830919'
	insert into #tmp_num_proc_num_po select  'EMCSR201911108BR','4004822221'
	insert into #tmp_num_proc_num_po select  'EMCSR201912011BR','4004741599'
	insert into #tmp_num_proc_num_po select  'EMCSR201912017BR','0150683810'
	insert into #tmp_num_proc_num_po select  'EMCSR201912023BR','4004787546'
	insert into #tmp_num_proc_num_po select  'EMCSR201912043BR','4004827990'
	insert into #tmp_num_proc_num_po select  'EMCSR201912061BR','4004852986'
	insert into #tmp_num_proc_num_po select  'EMCSR201912067BR','4004832338'
	insert into #tmp_num_proc_num_po select  'EMCSR201912074BR','4004832339'
	insert into #tmp_num_proc_num_po select  'EMCSR201912075BR','4004871667'
	insert into #tmp_num_proc_num_po select  'EMCSR201912076BR','0110559212'
	insert into #tmp_num_proc_num_po select  'EMCSR201912077BR','0150693873'
	insert into #tmp_num_proc_num_po select  'EMCSR201912083BR','4004868825'
	insert into #tmp_num_proc_num_po select  'EMCSR201912090BR','4004797208'
	insert into #tmp_num_proc_num_po select  'EMCSR201912091BR','4004870009'
	insert into #tmp_num_proc_num_po select  'EMCSR201912094BR','4004866250'
	insert into #tmp_num_proc_num_po select  'EMCSR201912095BR','4004548157'
	insert into #tmp_num_proc_num_po select  'EMCSR202001005BR','4004548160'
	insert into #tmp_num_proc_num_po select  'EMCSR202001006BR','4004548144'
	insert into #tmp_num_proc_num_po select  'EMCSR202001007BR','4004548161'
	insert into #tmp_num_proc_num_po select  'EMCSR202001014BR','4004869965'
	insert into #tmp_num_proc_num_po select  'EMCSR202001017BR','4004822592'
	insert into #tmp_num_proc_num_po select  'EMCSR202001018BR','4004822593'
	insert into #tmp_num_proc_num_po select  'EMCSR202001022BR','4004843508'
	insert into #tmp_num_proc_num_po select  'EMCSR202001025BR','0150693875'
	insert into #tmp_num_proc_num_po select  'EMCSR202001027BR','4004822354'
	insert into #tmp_num_proc_num_po select  'EMCSR202001028BR','4004835743'
	insert into #tmp_num_proc_num_po select  'EMCSR202001030BR','4004889160'
	insert into #tmp_num_proc_num_po select  'EMCSR202001033BR','4004776946'
	insert into #tmp_num_proc_num_po select  'EMCSR202001037BR','110546269'
	insert into #tmp_num_proc_num_po select  'EMCSR202001039BR','4004869668'
	insert into #tmp_num_proc_num_po select  'EMCSR202001048BR','4004837937'
	insert into #tmp_num_proc_num_po select  'EMCSR202001051BR','4004917139'
	insert into #tmp_num_proc_num_po select  'EMCSR202001053BR','4004918509'
	insert into #tmp_num_proc_num_po select  'EMCSR202001062BR','4004868853'
	insert into #tmp_num_proc_num_po select  'EMCSR202001063BR','110545930'
	insert into #tmp_num_proc_num_po select  'EMCSR202001065BR','4004548164'
	insert into #tmp_num_proc_num_po select  'EMCSR202001069BR','4004929879'
	insert into #tmp_num_proc_num_po select  'EMCSR202001073BR','4004926508'
	insert into #tmp_num_proc_num_po select  'EMCSR202001074BR','4004930272'
	insert into #tmp_num_proc_num_po select  'EMCSR202001075BR','4004930276'
	insert into #tmp_num_proc_num_po select  'EMCSR202001078BR','4004741611'
	insert into #tmp_num_proc_num_po select  'EMCSR202001080BR','4004932698'
	insert into #tmp_num_proc_num_po select  'EMCSR202001086BR','4004917154'
	insert into #tmp_num_proc_num_po select  'EMCSR202001088BR','4004829321'
	insert into #tmp_num_proc_num_po select  'EMCSR202001089BR','4004886918'
	insert into #tmp_num_proc_num_po select  'EMCSR202001092BR','4004886921'
	insert into #tmp_num_proc_num_po select  'EMCSR202001093BR','4004930224'
	insert into #tmp_num_proc_num_po select  'EMCSR202001095BR','4004933604'
	insert into #tmp_num_proc_num_po select  'EACSR201912001BR','0109994510'
	insert into #tmp_num_proc_num_po select  'EACSR202001003BR','0110408377'
	insert into #tmp_num_proc_num_po select  'EACSR202003001BR','4004991967'
	insert into #tmp_num_proc_num_po select  'EACSR202003003BR','1167MM'
	insert into #tmp_num_proc_num_po select  'EACSR202003005BR','0110844423'
	insert into #tmp_num_proc_num_po select  'EACSR202005001BR','00764EN'
	insert into #tmp_num_proc_num_po select  'EACSR202007002BR','0292LV'
	insert into #tmp_num_proc_num_po select  'EACSR202010001BR','4005525718'
	insert into #tmp_num_proc_num_po select  'EACSR202010003BR','0150758299 - 150758299'
	insert into #tmp_num_proc_num_po select  'EACSR202101001BR','4005584126'
	insert into #tmp_num_proc_num_po select  'EMCSR201711079BR','4002995382'
	insert into #tmp_num_proc_num_po select  'EMCSR201711090BR','4002995427'
	insert into #tmp_num_proc_num_po select  'EMCSR201711097BR','4002959819'
	insert into #tmp_num_proc_num_po select  'EMCSR201911068BR','4004800487'
	insert into #tmp_num_proc_num_po select  'EMCSR201911075BR','150677811'
	insert into #tmp_num_proc_num_po select  'EMCSR201911079BR','4004705739'
	insert into #tmp_num_proc_num_po select  'EMCSR201912012BR','4004741591'
	insert into #tmp_num_proc_num_po select  'EMCSR201912022BR','4004831649'
	insert into #tmp_num_proc_num_po select  'EMCSR201912024BR','4004741593'
	insert into #tmp_num_proc_num_po select  'EMCSR201912034BR','4004722863'
	insert into #tmp_num_proc_num_po select  'EMCSR201912041BR','4004722880'
	insert into #tmp_num_proc_num_po select  'EMCSR201912042BR','4004759882'
	insert into #tmp_num_proc_num_po select  'EMCSR201912050BR','4004759888'
	insert into #tmp_num_proc_num_po select  'EMCSR201912052BR','4004835881'
	insert into #tmp_num_proc_num_po select  'EMCSR201912063BR','0150693872'
	insert into #tmp_num_proc_num_po select  'EMCSR201912064BR','4004801320'
	insert into #tmp_num_proc_num_po select  'EMCSR201912079BR','4004827993'
	insert into #tmp_num_proc_num_po select  'EMCSR201912081BR','4004868830'
	insert into #tmp_num_proc_num_po select  'EMCSR201912082BR','0150693874'
	insert into #tmp_num_proc_num_po select  'EMCSR201912084BR','110620574'
	insert into #tmp_num_proc_num_po select  'EMCSR201912088BR','4004883757'
	insert into #tmp_num_proc_num_po select  'EMCSR201912089BR','4004883759'
	insert into #tmp_num_proc_num_po select  'EMCSR201912092BR','4004827673'
	insert into #tmp_num_proc_num_po select  'EMCSR201912093BR','4004870881'
	insert into #tmp_num_proc_num_po select  'EMCSR202001002BR','0150693487'
	insert into #tmp_num_proc_num_po select  'EMCSR202001003BR','4004843505'
	insert into #tmp_num_proc_num_po select  'EMCSR202001004BR','4004548159'
	insert into #tmp_num_proc_num_po select  'EMCSR202001009BR','0110444136'
	insert into #tmp_num_proc_num_po select  'EMCSR202001010BR','4004786624'
	insert into #tmp_num_proc_num_po select  'EMCSR202001013BR','4004832258'
	insert into #tmp_num_proc_num_po select  'EMCSR202001015BR','4004822585'
	insert into #tmp_num_proc_num_po select  'EMCSR202001023BR','4004787567'
	insert into #tmp_num_proc_num_po select  'EMCSR202001032BR','0150696180'
	insert into #tmp_num_proc_num_po select  'EMCSR202001034BR','0150694767 - 150694767'
	insert into #tmp_num_proc_num_po select  'EMCSR202001035BR','110546304'
	insert into #tmp_num_proc_num_po select  'EMCSR202001036BR','110546290'
	insert into #tmp_num_proc_num_po select  'EMCSR202001038BR','110545948'
	insert into #tmp_num_proc_num_po select  'EMCSR202001041BR','4004873693'
	insert into #tmp_num_proc_num_po select  'EMCSR202001042BR','4004925755'
	insert into #tmp_num_proc_num_po select  'EMCSR202001043BR','0150695249'
	insert into #tmp_num_proc_num_po select  'EMCSR202001046BR','4004889141'
	insert into #tmp_num_proc_num_po select  'EMCSR202001047BR','4004857715'
	insert into #tmp_num_proc_num_po select  'EMCSR202001050BR','4004914216'
	insert into #tmp_num_proc_num_po select  'EMCSR202001081BR','4004817071'
	insert into #tmp_num_proc_num_po select  'EMCSR202001083BR','4004932717'
	insert into #tmp_num_proc_num_po select  'EMCSR202001084BR','4004837935'
	insert into #tmp_num_proc_num_po select  'EMCSR202001085BR','4004889695'
	insert into #tmp_num_proc_num_po select  'EMCSR202001087BR','150697343'
	insert into #tmp_num_proc_num_po select  'EMCSR202001091BR','4004930250'
	insert into #tmp_num_proc_num_po select  'EMCSR202001094BR','4004886922'
	insert into #tmp_num_proc_num_po select  'EMCSR202001102BR','110638173'
	insert into #tmp_num_proc_num_po select  'EMCSR202001104BR','4004790587'
	insert into #tmp_num_proc_num_po select  'EMCSR202001110BR','4004944686'
	insert into #tmp_num_proc_num_po select  'EMCSR202001113BR','4004955507'
	insert into #tmp_num_proc_num_po select  'EMCSR202001117BR','4004886920'
	insert into #tmp_num_proc_num_po select  'EMCSR202001119BR','4004548166'
	insert into #tmp_num_proc_num_po select  'EMCSR202002008BR','4004936623'
	insert into #tmp_num_proc_num_po select  'EMCSR202002009BR','0110724503'
	insert into #tmp_num_proc_num_po select  'EMCSR202002011BR','0150697345'
	insert into #tmp_num_proc_num_po select  'EMCSR202002018BR','4004935589'
	insert into #tmp_num_proc_num_po select  'EMCSR202002022BR','4004980276'
	insert into #tmp_num_proc_num_po select  'EMCSR202002025BR','0150705446'
	insert into #tmp_num_proc_num_po select  'EMCSR202002026BR','4004787568'
	insert into #tmp_num_proc_num_po select  'EMCSR202002027BR','4004944604'
	insert into #tmp_num_proc_num_po select  'EMCSR202002028BR','4004832348'
	insert into #tmp_num_proc_num_po select  'EMCSR202002033BR','4004998454'
	insert into #tmp_num_proc_num_po select  'EMCSR202002037BR','4004998496'
	insert into #tmp_num_proc_num_po select  'EMCSR202002042BR','4004999172'
	insert into #tmp_num_proc_num_po select  'EMCSR202002044BR','4004998506'
	insert into #tmp_num_proc_num_po select  'EMCSR202002058BR','4004999837'
	insert into #tmp_num_proc_num_po select  'EMCSR202002059BR','4004947209'
	insert into #tmp_num_proc_num_po select  'EMCSR202002061BR','4004975126'
	insert into #tmp_num_proc_num_po select  'EMCSR202002067BR','4005002092'
	insert into #tmp_num_proc_num_po select  'EMCSR202002069BR','4005002089'
	insert into #tmp_num_proc_num_po select  'EMCSR202002073BR','4004965609'
	insert into #tmp_num_proc_num_po select  'EMCSR202002075BR','4004965617'
	insert into #tmp_num_proc_num_po select  'EMCSR202002080BR','4005002094'
	insert into #tmp_num_proc_num_po select  'EMCSR202002081BR','4005002095'
	insert into #tmp_num_proc_num_po select  'EMCSR202002082BR','4005002097'
	insert into #tmp_num_proc_num_po select  'EMCSR202002084BR','4004868674'
	insert into #tmp_num_proc_num_po select  'EMCSR202002085BR','4004868673'
	insert into #tmp_num_proc_num_po select  'EMCSR202002086BR','4005010031'
	insert into #tmp_num_proc_num_po select  'EMCSR202002089BR','4004994249'
	insert into #tmp_num_proc_num_po select  'EMCSR202002091BR','4005012933'
	insert into #tmp_num_proc_num_po select  'EMCSR202002094BR','4005002449'
	insert into #tmp_num_proc_num_po select  'EMCSR202002097BR','4005019017'
	insert into #tmp_num_proc_num_po select  'EMCSR202002102BR','4004882061'
	insert into #tmp_num_proc_num_po select  'EMCSR202002109BR','4005005370'
	insert into #tmp_num_proc_num_po select  'EMCSR202003002BR','4005029217'
	insert into #tmp_num_proc_num_po select  'EMCSR202003003BR','4004950749'
	insert into #tmp_num_proc_num_po select  'EMCSR202003005BR','4004939250'
	insert into #tmp_num_proc_num_po select  'EMCSR202003008BR','4005044056'
	insert into #tmp_num_proc_num_po select  'EMCSR202003009BR','4004983802'
	insert into #tmp_num_proc_num_po select  'EMCSR202003011BR','4004868676'
	insert into #tmp_num_proc_num_po select  'EMCSR202003012BR','4004868679'
	insert into #tmp_num_proc_num_po select  'EMCSR202003013BR','4004868680'
	insert into #tmp_num_proc_num_po select  'EMCSR202003014BR','4004998527'
	insert into #tmp_num_proc_num_po select  'EMCSR202003027BR','4005042895'
	insert into #tmp_num_proc_num_po select  'EMCSR202003032BR','4005010021'
	insert into #tmp_num_proc_num_po select  'EMCSR202003036BR','4004868684'
	insert into #tmp_num_proc_num_po select  'EMCSR202001096BR','0150699056'
	insert into #tmp_num_proc_num_po select  'EMCSR202001097BR','0110715574'
	insert into #tmp_num_proc_num_po select  'EMCSR202001099BR','4004916525'
	insert into #tmp_num_proc_num_po select  'EMCSR202001100BR','4004790624'
	insert into #tmp_num_proc_num_po select  'EMCSR202001101BR','4004790593'
	insert into #tmp_num_proc_num_po select  'EMCSR202001116BR','4004955517'
	insert into #tmp_num_proc_num_po select  'EMCSR202001124BR','4004954020'
	insert into #tmp_num_proc_num_po select  'EMCSR202001125BR','4004958794'
	insert into #tmp_num_proc_num_po select  'EMCSR202001126BR','4004958803'
	insert into #tmp_num_proc_num_po select  'EMCSR202001128BR','4004958813'
	insert into #tmp_num_proc_num_po select  'EMCSR202002002BR','0110614752'
	insert into #tmp_num_proc_num_po select  'EMCSR202002004BR','4004790647'
	insert into #tmp_num_proc_num_po select  'EMCSR202002012BR','4004822355'
	insert into #tmp_num_proc_num_po select  'EMCSR202002014BR','4004947651'
	insert into #tmp_num_proc_num_po select  'EMCSR202002016BR','4004881967'
	insert into #tmp_num_proc_num_po select  'EMCSR202002019BR','4004967934'
	insert into #tmp_num_proc_num_po select  'EMCSR202002020BR','4004967973'
	insert into #tmp_num_proc_num_po select  'EMCSR202002029BR','4004947236'
	insert into #tmp_num_proc_num_po select  'EMCSR202002030BR','4004991750'
	insert into #tmp_num_proc_num_po select  'EMCSR202002031BR','4004998487'
	insert into #tmp_num_proc_num_po select  'EMCSR202002032BR','4004998457'
	insert into #tmp_num_proc_num_po select  'EMCSR202002034BR','4004998494'
	insert into #tmp_num_proc_num_po select  'EMCSR202002041BR','4004999167'
	insert into #tmp_num_proc_num_po select  'EMCSR202002043BR','4004999290'
	insert into #tmp_num_proc_num_po select  'EMCSR202002045BR','4004998514'
	insert into #tmp_num_proc_num_po select  'EMCSR202002046BR','4004998519'
	insert into #tmp_num_proc_num_po select  'EMCSR202002048BR','4004998530'
	insert into #tmp_num_proc_num_po select  'EMCSR202002054BR','0150697346'
	insert into #tmp_num_proc_num_po select  'EMCSR202002055BR','4004829313'
	insert into #tmp_num_proc_num_po select  'EMCSR202002056BR','4004837938'
	insert into #tmp_num_proc_num_po select  'EMCSR202002062BR','4004957840'
	insert into #tmp_num_proc_num_po select  'EMCSR202002063BR','4005005367'
	insert into #tmp_num_proc_num_po select  'EMCSR202002065BR','4004994944'
	insert into #tmp_num_proc_num_po select  'EMCSR202002066BR','4005005918'
	insert into #tmp_num_proc_num_po select  'EMCSR202002068BR','4005002091'
	insert into #tmp_num_proc_num_po select  'EMCSR202002076BR','4005009428'
	insert into #tmp_num_proc_num_po select  'EMCSR202002077BR','4005009895'
	insert into #tmp_num_proc_num_po select  'EMCSR202002079BR','4004994366'
	insert into #tmp_num_proc_num_po select  'EMCSR202002087BR','4005009434'
	insert into #tmp_num_proc_num_po select  'EMCSR202002088BR','4004980293'
	insert into #tmp_num_proc_num_po select  'EMCSR202002093BR','4005018981'
	insert into #tmp_num_proc_num_po select  'EMCSR202002096BR','4005019008'
	insert into #tmp_num_proc_num_po select  'EMCSR202002098BR','0150701763'
	insert into #tmp_num_proc_num_po select  'EMCSR202002099BR','4004869974'
	insert into #tmp_num_proc_num_po select  'EMCSR202002104BR','4005032036'
	insert into #tmp_num_proc_num_po select  'EMCSR202002106BR','4005022216'
	insert into #tmp_num_proc_num_po select  'EMCSR202002108BR','4005033513'
	insert into #tmp_num_proc_num_po select  'EMCSR202003010BR','4004983800'
	insert into #tmp_num_proc_num_po select  'EMCSR202003020BR','0150701764'
	insert into #tmp_num_proc_num_po select  'EMCSR202003021BR','4004998503'
	insert into #tmp_num_proc_num_po select  'EMCSR202003023BR','4005055488'
	insert into #tmp_num_proc_num_po select  'EMCSR202003025BR','4005047319'
	insert into #tmp_num_proc_num_po select  'EMCSR202003026BR','4005047314'
	insert into #tmp_num_proc_num_po select  'EMCSR202003042BR','4005047348'
	insert into #tmp_num_proc_num_po select  'EMCSR202003053BR','4005059068'
	insert into #tmp_num_proc_num_po select  'EMCSR202003054BR','4005059070'
	insert into #tmp_num_proc_num_po select  'EMCSR202001054BR','4004918517'
	insert into #tmp_num_proc_num_po select  'EMCSR202001055BR','4004921411'
	insert into #tmp_num_proc_num_po select  'EMCSR202001056BR','0110413644'
	insert into #tmp_num_proc_num_po select  'EMCSR202001057BR','110388158'
	insert into #tmp_num_proc_num_po select  'EMCSR202001058BR','0110388196'
	insert into #tmp_num_proc_num_po select  'EMCSR202001060BR','4004819505'
	insert into #tmp_num_proc_num_po select  'EMCSR202001061BR','4004892895'
	insert into #tmp_num_proc_num_po select  'EMCSR202001066BR','4004787573'
	insert into #tmp_num_proc_num_po select  'EMCSR202001068BR','110546330'
	insert into #tmp_num_proc_num_po select  'EMCSR202001076BR','4004822278'
	insert into #tmp_num_proc_num_po select  'EMCSR202001079BR','4004932664'
	insert into #tmp_num_proc_num_po select  'EMCSR202001082BR','4004887338'
	insert into #tmp_num_proc_num_po select  'EMCSR202001090BR','4004886919'
	insert into #tmp_num_proc_num_po select  'EMCSR202001098BR','4004921412'
	insert into #tmp_num_proc_num_po select  'EMCSR202001103BR','4004886923'
	insert into #tmp_num_proc_num_po select  'EMCSR202001106BR','150698622'
	insert into #tmp_num_proc_num_po select  'EMCSR202001107BR','4004926349'
	insert into #tmp_num_proc_num_po select  'EMCSR202001108BR','4004886924'
	insert into #tmp_num_proc_num_po select  'EMCSR202001109BR','4004886925'
	insert into #tmp_num_proc_num_po select  'EMCSR202001111BR','4004944687'
	insert into #tmp_num_proc_num_po select  'EMCSR202001112BR','4004955495'
	insert into #tmp_num_proc_num_po select  'EMCSR202001114BR','4004955513'
	insert into #tmp_num_proc_num_po select  'EMCSR202001118BR','4004548163'
	insert into #tmp_num_proc_num_po select  'EMCSR202001120BR','4004548162'
	insert into #tmp_num_proc_num_po select  'EMCSR202001121BR','0150703004'
	insert into #tmp_num_proc_num_po select  'EMCSR202001122BR','0110678337'
	insert into #tmp_num_proc_num_po select  'EMCSR202001123BR','4004958525'
	insert into #tmp_num_proc_num_po select  'EMCSR202001127BR','4004958809'
	insert into #tmp_num_proc_num_po select  'EMCSR202001129BR','4004958814'
	insert into #tmp_num_proc_num_po select  'EMCSR202001130BR','4004787552'
	insert into #tmp_num_proc_num_po select  'EMCSR202001131BR','4004790636'
	insert into #tmp_num_proc_num_po select  'EMCSR202001132BR','4004790639'
	insert into #tmp_num_proc_num_po select  'EMCSR202002001BR','4004886933'
	insert into #tmp_num_proc_num_po select  'EMCSR202002005BR','4004790642'
	insert into #tmp_num_proc_num_po select  'EMCSR202002006BR','4004790649'
	insert into #tmp_num_proc_num_po select  'EMCSR202002007BR','0150697344'
	insert into #tmp_num_proc_num_po select  'EMCSR202002010BR','4004916957'
	insert into #tmp_num_proc_num_po select  'EMCSR202002013BR','4004822356'
	insert into #tmp_num_proc_num_po select  'EMCSR202002015BR','4004947190'
	insert into #tmp_num_proc_num_po select  'EMCSR202002017BR','0150711605'
	insert into #tmp_num_proc_num_po select  'EMCSR202002021BR','4004950746'
	insert into #tmp_num_proc_num_po select  'EMCSR202002023BR','4004934952'
	insert into #tmp_num_proc_num_po select  'EMCSR202002024BR','4004944603'
	insert into #tmp_num_proc_num_po select  'EMCSR202002038BR','4004790660'
	insert into #tmp_num_proc_num_po select  'EMCSR202002039BR','4004790687'
	insert into #tmp_num_proc_num_po select  'EMCSR202002049BR','4004998522'
	insert into #tmp_num_proc_num_po select  'EMCSR202002050BR','4004998534'
	insert into #tmp_num_proc_num_po select  'EMCSR202002052BR','4004999173'
	insert into #tmp_num_proc_num_po select  'EMCSR202002053BR','4004787574'
	insert into #tmp_num_proc_num_po select  'EMCSR202002057BR','4004994251'
	insert into #tmp_num_proc_num_po select  'EMCSR202002060BR','0150706039'
	insert into #tmp_num_proc_num_po select  'EMCSR202002070BR','4005002087'
	insert into #tmp_num_proc_num_po select  'EMCSR202002071BR','4005002086'
	insert into #tmp_num_proc_num_po select  'EMCSR202002072BR','4004944606'
	insert into #tmp_num_proc_num_po select  'EMCSR202002074BR','4004965615'
	insert into #tmp_num_proc_num_po select  'EMCSR202002078BR','4005002897'
	insert into #tmp_num_proc_num_po select  'EMCSR202002083BR','4004868675'
	insert into #tmp_num_proc_num_po select  'EMCSR202003037BR','4004868685'
	insert into #tmp_num_proc_num_po select  'EMCSR202003043BR','4004921241'
	insert into #tmp_num_proc_num_po select  'EMCSR202003044BR','4004921242'
	insert into #tmp_num_proc_num_po select  'EMCSR202003047BR','4005053044'
	insert into #tmp_num_proc_num_po select  'EMCSR202003048BR','4005059055'
	insert into #tmp_num_proc_num_po select  'EMCSR202003049BR','4005073974'
	insert into #tmp_num_proc_num_po select  'EMCSR202003051BR','4005059064'
	insert into #tmp_num_proc_num_po select  'EMCSR202003057BR','0150711785'
	insert into #tmp_num_proc_num_po select  'EMCSR202003059BR','4005024415'
	insert into #tmp_num_proc_num_po select  'EMCSR202003061BR','4005024419'
	insert into #tmp_num_proc_num_po select  'EMCSR202003064BR','0150714445'
	insert into #tmp_num_proc_num_po select  'EMCSR202003070BR','0110934671'
	insert into #tmp_num_proc_num_po select  'EMCSR202003071BR','4005079797'
	insert into #tmp_num_proc_num_po select  'EMCSR202003073BR','4005024420'
	insert into #tmp_num_proc_num_po select  'EMCSR202003075BR','4004787571'
	insert into #tmp_num_proc_num_po select  'EMCSR202003077BR','0150715074'
	insert into #tmp_num_proc_num_po select  'EMCSR202003081BR','0150714951'
	insert into #tmp_num_proc_num_po select  'EMCSR202003082BR','4005093125'
	insert into #tmp_num_proc_num_po select  'EMCSR202003084BR','4005003215'
	insert into #tmp_num_proc_num_po select  'EMCSR202003090BR','4005076762'
	insert into #tmp_num_proc_num_po select  'EMCSR202003092BR','4005093139'
	insert into #tmp_num_proc_num_po select  'EMCSR202003095BR','4005079435'
	insert into #tmp_num_proc_num_po select  'EMCSR202003099BR','4005080718'
	insert into #tmp_num_proc_num_po select  'EMCSR202003103BR','4005101935'
	insert into #tmp_num_proc_num_po select  'EMCSR202003108BR','4005002166'
	insert into #tmp_num_proc_num_po select  'EMCSR202003109BR','4005002167'
	insert into #tmp_num_proc_num_po select  'EMCSR202003110BR','4005002169'
	insert into #tmp_num_proc_num_po select  'EMCSR202003113BR','4005106519'
	insert into #tmp_num_proc_num_po select  'EMCSR202003119BR','4005076955'
	insert into #tmp_num_proc_num_po select  'EMCSR202003120BR','0150711786'
	insert into #tmp_num_proc_num_po select  'EMCSR202003121BR','4005087965'
	insert into #tmp_num_proc_num_po select  'EMCSR202003126BR','4005078001'
	insert into #tmp_num_proc_num_po select  'EMCSR202003127BR','4005075768'
	insert into #tmp_num_proc_num_po select  'EMCSR202003136BR','0150714816'
	insert into #tmp_num_proc_num_po select  'EMCSR202004003BR','4004909230'
	insert into #tmp_num_proc_num_po select  'EMCSR202004007BR','4004951327'
	insert into #tmp_num_proc_num_po select  'EMCSR202004008BR','4004951329'
	insert into #tmp_num_proc_num_po select  'EMCSR202004012BR','4004951330'
	insert into #tmp_num_proc_num_po select  'EMCSR202004017BR','4005143210'
	insert into #tmp_num_proc_num_po select  'EMCSR202004030BR','4005135175'
	insert into #tmp_num_proc_num_po select  'EMCSR202004031BR','4005123322'
	insert into #tmp_num_proc_num_po select  'EMCSR202004034BR','4005024426'
	insert into #tmp_num_proc_num_po select  'EMCSR202004036BR','4005132372'
	insert into #tmp_num_proc_num_po select  'EMCSR202004037BR','4005132399'
	insert into #tmp_num_proc_num_po select  'EMCSR202004046BR','0111051856'
	insert into #tmp_num_proc_num_po select  'EMCSR202004049BR','4005029231'
	insert into #tmp_num_proc_num_po select  'EMCSR202004050BR','4005209399'
	insert into #tmp_num_proc_num_po select  'EMCSR202004053BR','4005209321'
	insert into #tmp_num_proc_num_po select  'EMCSR202004062BR','4005157776'
	insert into #tmp_num_proc_num_po select  'EMCSR202004067BR','4005158518'
	insert into #tmp_num_proc_num_po select  'EMCSR202004071BR','4005158429'
	insert into #tmp_num_proc_num_po select  'EMCSR202004073BR','4005176778'
	insert into #tmp_num_proc_num_po select  'EMCSR202004078BR','4005026084'
	insert into #tmp_num_proc_num_po select  'EMCSR202004079BR','4005181211'
	insert into #tmp_num_proc_num_po select  'EMCSR202004083BR','4005026087'
	insert into #tmp_num_proc_num_po select  'EMCSR202003056BR','4005059079'
	insert into #tmp_num_proc_num_po select  'EMCSR202003060BR','4005024418'
	insert into #tmp_num_proc_num_po select  'EMCSR202003063BR','4005131504'
	insert into #tmp_num_proc_num_po select  'EMCSR202003066BR','4005077999'
	insert into #tmp_num_proc_num_po select  'EMCSR202003072BR','4005079804'
	insert into #tmp_num_proc_num_po select  'EMCSR202003074BR','4005024421'
	insert into #tmp_num_proc_num_po select  'EMCSR202003076BR','4004944605'
	insert into #tmp_num_proc_num_po select  'EMCSR202003078BR','0110877877'
	insert into #tmp_num_proc_num_po select  'EMCSR202003085BR','4005018896'
	insert into #tmp_num_proc_num_po select  'EMCSR202003087BR','4005076410'
	insert into #tmp_num_proc_num_po select  'EMCSR202003089BR','4005079420'
	insert into #tmp_num_proc_num_po select  'EMCSR202003093BR','4005079421'
	insert into #tmp_num_proc_num_po select  'EMCSR202003094BR','4005079427'
	insert into #tmp_num_proc_num_po select  'EMCSR202003100BR','4005080908'
	insert into #tmp_num_proc_num_po select  'EMCSR202003101BR','4005080742'
	insert into #tmp_num_proc_num_po select  'EMCSR202003106BR','4005002168'
	insert into #tmp_num_proc_num_po select  'EMCSR202003107BR','4005002163'
	insert into #tmp_num_proc_num_po select  'EMCSR202003112BR','4005096134'
	insert into #tmp_num_proc_num_po select  'EMCSR202003116BR','4005101936'
	insert into #tmp_num_proc_num_po select  'EMCSR202003117BR','4005101937'
	insert into #tmp_num_proc_num_po select  'EMCSR202003122BR','4005076957'
	insert into #tmp_num_proc_num_po select  'EMCSR202003124BR','4004951319'
	insert into #tmp_num_proc_num_po select  'EMCSR202003125BR','0110967833'
	insert into #tmp_num_proc_num_po select  'EMCSR202003128BR','4005075808'
	insert into #tmp_num_proc_num_po select  'EMCSR202003132BR','4004951318'
	insert into #tmp_num_proc_num_po select  'EMCSR202003137BR','4004951324'
	insert into #tmp_num_proc_num_po select  'EMCSR202004001BR','0110809812'
	insert into #tmp_num_proc_num_po select  'EMCSR202004006BR','0110923019'
	insert into #tmp_num_proc_num_po select  'EMCSR202004009BR','4005003254'
	insert into #tmp_num_proc_num_po select  'EMCSR202004013BR','0110992892'
	insert into #tmp_num_proc_num_po select  'EMCSR202004016BR','4005146877'
	insert into #tmp_num_proc_num_po select  'EMCSR202004018BR','4005144008'
	insert into #tmp_num_proc_num_po select  'EMCSR202004020BR','4005141995'
	insert into #tmp_num_proc_num_po select  'EMCSR202004021BR','4005078009'
	insert into #tmp_num_proc_num_po select  'EMCSR202004024BR','4004951334'
	insert into #tmp_num_proc_num_po select  'EMCSR202004025BR','4005024423'
	insert into #tmp_num_proc_num_po select  'EMCSR202004027BR','4005073928'
	insert into #tmp_num_proc_num_po select  'EMCSR202004028BR','4005135165'
	insert into #tmp_num_proc_num_po select  'EMCSR202004032BR','4004951347'
	insert into #tmp_num_proc_num_po select  'EMCSR202004033BR','4004951351'
	insert into #tmp_num_proc_num_po select  'EMCSR202004035BR','4005150653'
	insert into #tmp_num_proc_num_po select  'EMCSR202004040BR','4005150674'
	insert into #tmp_num_proc_num_po select  'EMCSR202004043BR','4005209527'
	insert into #tmp_num_proc_num_po select  'EMCSR202004044BR','4005209430'
	insert into #tmp_num_proc_num_po select  'EMCSR202004047BR','4005209110'
	insert into #tmp_num_proc_num_po select  'EMCSR202004058BR','4005209470'
	insert into #tmp_num_proc_num_po select  'EMCSR202004059BR','0150721512'
	insert into #tmp_num_proc_num_po select  'EMCSR202004069BR','4005158425'
	insert into #tmp_num_proc_num_po select  'EMCSR202004072BR','0111041840'
	insert into #tmp_num_proc_num_po select  'EMCSR202004074BR','4005073929'
	insert into #tmp_num_proc_num_po select  'EMCSR202004075BR','4005026078'
	insert into #tmp_num_proc_num_po select  'EMCSR202004081BR','4005209239'
	insert into #tmp_num_proc_num_po select  'EMCSR202004082BR','4005059234'
	insert into #tmp_num_proc_num_po select  'EMCSR202002090BR','4005018874'
	insert into #tmp_num_proc_num_po select  'EMCSR202002092BR','4005013115'
	insert into #tmp_num_proc_num_po select  'EMCSR202002095BR','4005002450'
	insert into #tmp_num_proc_num_po select  'EMCSR202002107BR','4004980892'
	insert into #tmp_num_proc_num_po select  'EMCSR202002110BR','4005032041'
	insert into #tmp_num_proc_num_po select  'EMCSR202003001BR','4004994240'
	insert into #tmp_num_proc_num_po select  'EMCSR202003004BR','4005007079'
	insert into #tmp_num_proc_num_po select  'EMCSR202003006BR','4005022234'
	insert into #tmp_num_proc_num_po select  'EMCSR202003007BR','4005044058'
	insert into #tmp_num_proc_num_po select  'EMCSR202003015BR','4004787576'
	insert into #tmp_num_proc_num_po select  'EMCSR202003016BR','4004944608'
	insert into #tmp_num_proc_num_po select  'EMCSR202003017BR','4004944609'
	insert into #tmp_num_proc_num_po select  'EMCSR202003018BR','4004994362'
	insert into #tmp_num_proc_num_po select  'EMCSR202003019BR','4004882079'
	insert into #tmp_num_proc_num_po select  'EMCSR202003022BR','4005055471'
	insert into #tmp_num_proc_num_po select  'EMCSR202003028BR','4005042902'
	insert into #tmp_num_proc_num_po select  'EMCSR202003029BR','4005042904'
	insert into #tmp_num_proc_num_po select  'EMCSR202003030BR','4005042918'
	insert into #tmp_num_proc_num_po select  'EMCSR202003031BR','4004994371'
	insert into #tmp_num_proc_num_po select  'EMCSR202003034BR','4004868681'
	insert into #tmp_num_proc_num_po select  'EMCSR202003035BR','4004868683'
	insert into #tmp_num_proc_num_po select  'EMCSR202003038BR','0110877956'
	insert into #tmp_num_proc_num_po select  'EMCSR202003041BR','4005053023'
	insert into #tmp_num_proc_num_po select  'EMCSR202003045BR','4004787569'
	insert into #tmp_num_proc_num_po select  'EMCSR202003046BR','4005021760'
	insert into #tmp_num_proc_num_po select  'EMCSR202003050BR','4005059061'
	insert into #tmp_num_proc_num_po select  'EMCSR202003052BR','4005059066'
	insert into #tmp_num_proc_num_po select  'EMCSR202003055BR','4005059075'
	insert into #tmp_num_proc_num_po select  'EMCSR202003058BR','0150711916'
	insert into #tmp_num_proc_num_po select  'EMCSR202003062BR','4005020295'
	insert into #tmp_num_proc_num_po select  'EMCSR202003065BR','0110715524'
	insert into #tmp_num_proc_num_po select  'EMCSR202003067BR','4005077193'
	insert into #tmp_num_proc_num_po select  'EMCSR202003068BR','4005077192'
	insert into #tmp_num_proc_num_po select  'EMCSR202003069BR','0110909234'
	insert into #tmp_num_proc_num_po select  'EMCSR202003083BR','4005093132'
	insert into #tmp_num_proc_num_po select  'EMCSR202003088BR','4005076405'
	insert into #tmp_num_proc_num_po select  'EMCSR202003091BR','4005080715'
	insert into #tmp_num_proc_num_po select  'EMCSR202003096BR','4005080730'
	insert into #tmp_num_proc_num_po select  'EMCSR202003097BR','4005080907'
	insert into #tmp_num_proc_num_po select  'EMCSR202003098BR','4005080897'
	insert into #tmp_num_proc_num_po select  'EMCSR202003102BR','0110961258'
	insert into #tmp_num_proc_num_po select  'EMCSR202003104BR','4005002090'
	insert into #tmp_num_proc_num_po select  'EMCSR202003105BR','4005002160'
	insert into #tmp_num_proc_num_po select  'EMCSR202003111BR','0150715092'
	insert into #tmp_num_proc_num_po select  'EMCSR202003118BR','4005101951'
	insert into #tmp_num_proc_num_po select  'EMCSR202003123BR','4004951315'
	insert into #tmp_num_proc_num_po select  'EMCSR202003129BR','4005078000'
	insert into #tmp_num_proc_num_po select  'EMCSR202003133BR','4005063102'
	insert into #tmp_num_proc_num_po select  'EMCSR202003138BR','4004951325'
	insert into #tmp_num_proc_num_po select  'EMCSR202004004BR','4004951323'
	insert into #tmp_num_proc_num_po select  'EMCSR202004005BR','4005100272'
	insert into #tmp_num_proc_num_po select  'EMCSR202004010BR','4005073924'
	insert into #tmp_num_proc_num_po select  'EMCSR202004011BR','4005073925'
	insert into #tmp_num_proc_num_po select  'EMCSR202004014BR','0150711787'
	insert into #tmp_num_proc_num_po select  'EMCSR202004023BR','4004951333'
	insert into #tmp_num_proc_num_po select  'EMCSR202004026BR','4004974748'
	insert into #tmp_num_proc_num_po select  'EMCSR202004029BR','4005135169'
	insert into #tmp_num_proc_num_po select  'EMCSR202004038BR','4005209092'
	insert into #tmp_num_proc_num_po select  'EMCSR202004042BR','4005042571'
	insert into #tmp_num_proc_num_po select  'EMCSR202004048BR','4005172595'
	insert into #tmp_num_proc_num_po select  'EMCSR202004054BR','4005209512'
	insert into #tmp_num_proc_num_po select  'EMCSR202004057BR','0150712801'
	insert into #tmp_num_proc_num_po select  'EMCSR202004060BR','4005209459'
	insert into #tmp_num_proc_num_po select  'EMCSR202004061BR','4005157775'
	insert into #tmp_num_proc_num_po select  'EMCSR202004063BR','4005157780'
	insert into #tmp_num_proc_num_po select  'EMCSR202004064BR','4005157785'
	insert into #tmp_num_proc_num_po select  'EMCSR202004065BR','4005157787'
	insert into #tmp_num_proc_num_po select  'EMCSR202004066BR','4005157788'
	insert into #tmp_num_proc_num_po select  'EMCSR202004068BR','4005158420'
	insert into #tmp_num_proc_num_po select  'EMCSR202004070BR','4005158428'
	insert into #tmp_num_proc_num_po select  'EMCSR202004076BR','4005026080'
	insert into #tmp_num_proc_num_po select  'EMCSR202004077BR','4005026083'
	insert into #tmp_num_proc_num_po select  'EMCSR202004084BR','4005026088'
	insert into #tmp_num_proc_num_po select  'EMCSR202004085BR','4005026089'
	insert into #tmp_num_proc_num_po select  'EMCSR202004087BR','4005209455'
	insert into #tmp_num_proc_num_po select  'EMCSR202004090BR','4005209391'
	insert into #tmp_num_proc_num_po select  'EMCSR202004095BR','4005209461'
	insert into #tmp_num_proc_num_po select  'EMCSR202005002BR','0150723948'
	insert into #tmp_num_proc_num_po select  'EMCSR202005006BR','4005210275'
	insert into #tmp_num_proc_num_po select  'EMCSR202005007BR','4005157731'
	insert into #tmp_num_proc_num_po select  'EMCSR202005008BR','4005157733'
	insert into #tmp_num_proc_num_po select  'EMCSR202005015BR','4005158516'
	insert into #tmp_num_proc_num_po select  'EMCSR202005018BR','4005209224'
	insert into #tmp_num_proc_num_po select  'EMCSR202005022BR','0111088168'
	insert into #tmp_num_proc_num_po select  'EMCSR202005024BR','4005209363'
	insert into #tmp_num_proc_num_po select  'EMCSR202005033BR','4005209203'
	insert into #tmp_num_proc_num_po select  'EMCSR202005041BR','4005209231'
	insert into #tmp_num_proc_num_po select  'EMCSR202005045BR','4005212742'
	insert into #tmp_num_proc_num_po select  'EMCSR202005046BR','4005212725'
	insert into #tmp_num_proc_num_po select  'EMCSR202005047BR','4005213148'
	insert into #tmp_num_proc_num_po select  'EMCSR202005051BR','4005026093'
	insert into #tmp_num_proc_num_po select  'EMCSR202005054BR','4005026098'
	insert into #tmp_num_proc_num_po select  'EMCSR202005061BR','4005224408'
	insert into #tmp_num_proc_num_po select  'EMCSR202005062BR','4005143254'
	insert into #tmp_num_proc_num_po select  'EMCSR202005065BR','4005026106'
	insert into #tmp_num_proc_num_po select  'EMCSR202005069BR','4005158532'
	insert into #tmp_num_proc_num_po select  'EMCSR202005083BR','4005224469'
	insert into #tmp_num_proc_num_po select  'EMCSR202005085BR','4005224485'
	insert into #tmp_num_proc_num_po select  'EMCSR202005096BR','4005208894'
	insert into #tmp_num_proc_num_po select  'EMCSR202005099BR','4005209189'
	insert into #tmp_num_proc_num_po select  'EMCSR202005100BR','4005224425'
	insert into #tmp_num_proc_num_po select  'EMCSR202006001BR','4005259273'
	insert into #tmp_num_proc_num_po select  'EMCSR202006003BR','4005259283'
	insert into #tmp_num_proc_num_po select  'EMCSR202006007BR','4005209465'
	insert into #tmp_num_proc_num_po select  'EMCSR202006008BR','0111223982'
	insert into #tmp_num_proc_num_po select  'EMCSR202006009BR','4005253025'
	insert into #tmp_num_proc_num_po select  'EMCSR202006014BR','4005158523'
	insert into #tmp_num_proc_num_po select  'EMCSR202006021BR','4005230034'
	insert into #tmp_num_proc_num_po select  'EMCSR202004086BR','4005026090'
	insert into #tmp_num_proc_num_po select  'EMCSR202004088BR','4005209421'
	insert into #tmp_num_proc_num_po select  'EMCSR202004089BR','4005209401'
	insert into #tmp_num_proc_num_po select  'EMCSR202004092BR','4005209469'
	insert into #tmp_num_proc_num_po select  'EMCSR202004096BR','4005134898'
	insert into #tmp_num_proc_num_po select  'EMCSR202005001BR','4005157728'
	insert into #tmp_num_proc_num_po select  'EMCSR202005009BR','4005158527'
	insert into #tmp_num_proc_num_po select  'EMCSR202005010BR','4005157736'
	insert into #tmp_num_proc_num_po select  'EMCSR202005011BR','4005158528'
	insert into #tmp_num_proc_num_po select  'EMCSR202005012BR','4005158435'
	insert into #tmp_num_proc_num_po select  'EMCSR202005013BR','4005158437'
	insert into #tmp_num_proc_num_po select  'EMCSR202005014BR','4005158441'
	insert into #tmp_num_proc_num_po select  'EMCSR202005016BR','4005157782'
	insert into #tmp_num_proc_num_po select  'EMCSR202005017BR','0111093742'
	insert into #tmp_num_proc_num_po select  'EMCSR202005019BR','0110982628'
	insert into #tmp_num_proc_num_po select  'EMCSR202005020BR','110910299'
	insert into #tmp_num_proc_num_po select  'EMCSR202005025BR','4005209207'
	insert into #tmp_num_proc_num_po select  'EMCSR202005029BR','4005174062'
	insert into #tmp_num_proc_num_po select  'EMCSR202005031BR','4005209255'
	insert into #tmp_num_proc_num_po select  'EMCSR202005032BR','4005209154'
	insert into #tmp_num_proc_num_po select  'EMCSR202005037BR','4005073923'
	insert into #tmp_num_proc_num_po select  'EMCSR202005038BR','4005127121'
	insert into #tmp_num_proc_num_po select  'EMCSR202005042BR','4005158431'
	insert into #tmp_num_proc_num_po select  'EMCSR202005049BR','4005209094'
	insert into #tmp_num_proc_num_po select  'EMCSR202005052BR','4005026094'
	insert into #tmp_num_proc_num_po select  'EMCSR202005053BR','4005026095'
	insert into #tmp_num_proc_num_po select  'EMCSR202005057BR','4005232033'
	insert into #tmp_num_proc_num_po select  'EMCSR202005058BR','4005227559'
	insert into #tmp_num_proc_num_po select  'EMCSR202005064BR','4005026102'
	insert into #tmp_num_proc_num_po select  'EMCSR202005067BR','4005214551'
	insert into #tmp_num_proc_num_po select  'EMCSR202005073BR','4005224462'
	insert into #tmp_num_proc_num_po select  'EMCSR202005076BR','4005224467'
	insert into #tmp_num_proc_num_po select  'EMCSR202005078BR','4005231819'
	insert into #tmp_num_proc_num_po select  'EMCSR202005079BR','4005231024'
	insert into #tmp_num_proc_num_po select  'EMCSR202005082BR','4005224468'
	insert into #tmp_num_proc_num_po select  'EMCSR202005089BR','4005223879'
	insert into #tmp_num_proc_num_po select  'EMCSR202005091BR','4005242143'
	insert into #tmp_num_proc_num_po select  'EMCSR202005094BR','4005208590'
	insert into #tmp_num_proc_num_po select  'EMCSR202005095BR','4005208898'
	insert into #tmp_num_proc_num_po select  'EMCSR202005102BR','4005224422'
	insert into #tmp_num_proc_num_po select  'EMCSR202005103BR','4005224423'
	insert into #tmp_num_proc_num_po select  'EMCSR202006005BR','4005262275'
	insert into #tmp_num_proc_num_po select  'EMCSR202006006BR','4005223878'
	insert into #tmp_num_proc_num_po select  'EMCSR202006012BR','4005238903'
	insert into #tmp_num_proc_num_po select  'EMCSR202006013BR','4005208593'
	insert into #tmp_num_proc_num_po select  'EMCSR202006017BR','4005225089'
	insert into #tmp_num_proc_num_po select  'EMCSR202006018BR','4005271084'
	insert into #tmp_num_proc_num_po select  'EMCSR202006020BR','0111228749'
	insert into #tmp_num_proc_num_po select  'EMCSR202006022BR','4005230036'
	insert into #tmp_num_proc_num_po select  'EMCSR202006023BR','4005189698'
	insert into #tmp_num_proc_num_po select  'EMCSR202006027BR','4005270888'
	insert into #tmp_num_proc_num_po select  'EMCSR202006038BR','4005238646'
	insert into #tmp_num_proc_num_po select  'EMCSR202006048BR','4005291726'
	insert into #tmp_num_proc_num_po select  'EMCSR202006050BR','4005291725'
	insert into #tmp_num_proc_num_po select  'EMCSR202006051BR','4005291729'
	insert into #tmp_num_proc_num_po select  'EMCSR202006053BR','0150733613'
	insert into #tmp_num_proc_num_po select  'EMCSR202006055BR','4005259166'
	insert into #tmp_num_proc_num_po select  'EMCSR202006056BR','4005270748'
	insert into #tmp_num_proc_num_po select  'EMCSR202006067BR','0150733614'
	insert into #tmp_num_proc_num_po select  'EMCSR202006068BR','4005224491'
	insert into #tmp_num_proc_num_po select  'EMCSR202006072BR','4005290160'
	insert into #tmp_num_proc_num_po select  'EMCSR202006073BR','4005297865'
	insert into #tmp_num_proc_num_po select  'EMCSR202006075BR','4005254439'
	insert into #tmp_num_proc_num_po select  'EMCSR202006076BR','4005303924'
	insert into #tmp_num_proc_num_po select  'EMCSR202006079BR','0111302748'
	insert into #tmp_num_proc_num_po select  'EMCSR202006086BR','4005300988'
	insert into #tmp_num_proc_num_po select  'EMCSR202007006BR','4005209213'
	insert into #tmp_num_proc_num_po select  'EMCSR202007011BR','4005270754'
	insert into #tmp_num_proc_num_po select  'EMCSR202007013BR','4005270863'
	insert into #tmp_num_proc_num_po select  'EMCSR202007015BR','4005300985'
	insert into #tmp_num_proc_num_po select  'EMCSR202007031BR','4005336047'
	insert into #tmp_num_proc_num_po select  'EMCSR202007039BR','4005242950'
	insert into #tmp_num_proc_num_po select  'EMCSR202007043BR','4005356087'
	insert into #tmp_num_proc_num_po select  'EMCSR202007044BR','4005321523'
	insert into #tmp_num_proc_num_po select  'EMCSR202007045BR','4005321529'
	insert into #tmp_num_proc_num_po select  'EMCSR202007047BR','0111307918'
	insert into #tmp_num_proc_num_po select  'EMCSR202007048BR','4005343447'
	insert into #tmp_num_proc_num_po select  'EMCSR202007049BR','4005350712'
	insert into #tmp_num_proc_num_po select  'EMCSR202007050BR','4005328504'
	insert into #tmp_num_proc_num_po select  'EMCSR202007051BR','4005328506'
	insert into #tmp_num_proc_num_po select  'EMCSR202007053BR','4005328520'
	insert into #tmp_num_proc_num_po select  'EMCSR202007056BR','4005358821'
	insert into #tmp_num_proc_num_po select  'EMCSR202007063BR','4005335972'
	insert into #tmp_num_proc_num_po select  'EMCSR202007065BR','4005326828'
	insert into #tmp_num_proc_num_po select  'EMCSR202007068BR','4005350445'
	insert into #tmp_num_proc_num_po select  'EMCSR202007070BR','4005343450'
	insert into #tmp_num_proc_num_po select  'EMCSR202007071BR','4005323274'
	insert into #tmp_num_proc_num_po select  'EMCSR202007073BR','4005230074'
	insert into #tmp_num_proc_num_po select  'EMCSR202007080BR','4005358803'
	insert into #tmp_num_proc_num_po select  'EMCSR202007083BR','4005369894'
	insert into #tmp_num_proc_num_po select  'EMCSR202007085BR','4005224500'
	insert into #tmp_num_proc_num_po select  'EMCSR202007086BR','4005224504'
	insert into #tmp_num_proc_num_po select  'EMCSR202007087BR','4005260010'
	insert into #tmp_num_proc_num_po select  'EMCSR202007090BR','4005260017'
	insert into #tmp_num_proc_num_po select  'EMCSR202007091BR','4005260018'
	insert into #tmp_num_proc_num_po select  'EMCSR202007092BR','4005224494'
	insert into #tmp_num_proc_num_po select  'EMCSR202007093BR','4005224506'
	insert into #tmp_num_proc_num_po select  'EMCSR202007094BR','4005382681'
	insert into #tmp_num_proc_num_po select  'EMCSR202007095BR','4005329184'
	insert into #tmp_num_proc_num_po select  'EMCSR202008003BR','0111383767'
	insert into #tmp_num_proc_num_po select  'EMCSR202008004BR','4005265267'
	insert into #tmp_num_proc_num_po select  'EMCSR202008006BR','4005379773'
	insert into #tmp_num_proc_num_po select  'EMCSR202008010BR','37245933 - 4005376813'
	insert into #tmp_num_proc_num_po select  'EMCSR202008011BR','4005247664'
	insert into #tmp_num_proc_num_po select  'EMCSR202008012BR','4005369899'
	insert into #tmp_num_proc_num_po select  'EMCSR202008015BR','4005359912'
	insert into #tmp_num_proc_num_po select  'EMCSR202008016BR','4005398860'
	insert into #tmp_num_proc_num_po select  'EMCSR202008020BR','4005417450'
	insert into #tmp_num_proc_num_po select  'EMCSR202008024BR','4005412377'
	insert into #tmp_num_proc_num_po select  'EMCSR202004091BR','4005209275'
	insert into #tmp_num_proc_num_po select  'EMCSR202004093BR','4005209456'
	insert into #tmp_num_proc_num_po select  'EMCSR202004094BR','4005209477'
	insert into #tmp_num_proc_num_po select  'EMCSR202004103BR','4005198662'
	insert into #tmp_num_proc_num_po select  'EMCSR202004104BR','4005196968'
	insert into #tmp_num_proc_num_po select  'EMCSR202004105BR','4005196965'
	insert into #tmp_num_proc_num_po select  'EMCSR202004106BR','4005196967'
	insert into #tmp_num_proc_num_po select  'EMCSR202005003BR','0150723949'
	insert into #tmp_num_proc_num_po select  'EMCSR202005004BR','4005209435'
	insert into #tmp_num_proc_num_po select  'EMCSR202005005BR','4005209403'
	insert into #tmp_num_proc_num_po select  'EMCSR202005021BR','4005209271'
	insert into #tmp_num_proc_num_po select  'EMCSR202005027BR','4005173823'
	insert into #tmp_num_proc_num_po select  'EMCSR202005028BR','4005209351'
	insert into #tmp_num_proc_num_po select  'EMCSR202005030BR','4005061539'
	insert into #tmp_num_proc_num_po select  'EMCSR202005040BR','4005209141'
	insert into #tmp_num_proc_num_po select  'EMCSR202005044BR','4005212756'
	insert into #tmp_num_proc_num_po select  'EMCSR202005048BR','4005213140'
	insert into #tmp_num_proc_num_po select  'EMCSR202005050BR','4005223585'
	insert into #tmp_num_proc_num_po select  'EMCSR202005056BR','4005223540'
	insert into #tmp_num_proc_num_po select  'EMCSR202005059BR','4005230031'
	insert into #tmp_num_proc_num_po select  'EMCSR202005060BR','4005209226'
	insert into #tmp_num_proc_num_po select  'EMCSR202005063BR','4005225013'
	insert into #tmp_num_proc_num_po select  'EMCSR202005066BR','4005214535'
	insert into #tmp_num_proc_num_po select  'EMCSR202005068BR','4005214553'
	insert into #tmp_num_proc_num_po select  'EMCSR202005070BR','4005026107'
	insert into #tmp_num_proc_num_po select  'EMCSR202005071BR','0111077131'
	insert into #tmp_num_proc_num_po select  'EMCSR202005074BR','4005224463'
	insert into #tmp_num_proc_num_po select  'EMCSR202005075BR','4005224465'
	insert into #tmp_num_proc_num_po select  'EMCSR202005080BR','4005224461'
	insert into #tmp_num_proc_num_po select  'EMCSR202005081BR','4005224487'
	insert into #tmp_num_proc_num_po select  'EMCSR202005084BR','4005224475'
	insert into #tmp_num_proc_num_po select  'EMCSR202005090BR','4005223880'
	insert into #tmp_num_proc_num_po select  'EMCSR202005092BR','4005242144'
	insert into #tmp_num_proc_num_po select  'EMCSR202005093BR','4005158521'
	insert into #tmp_num_proc_num_po select  'EMCSR202005097BR','4005208892'
	insert into #tmp_num_proc_num_po select  'EMCSR202005098BR','4005208888'
	insert into #tmp_num_proc_num_po select  'EMCSR202005101BR','0111160327'
	insert into #tmp_num_proc_num_po select  'EMCSR202006002BR','4005259279'
	insert into #tmp_num_proc_num_po select  'EMCSR202006004BR','4005262250'
	insert into #tmp_num_proc_num_po select  'EMCSR202006010BR','4005223881'
	insert into #tmp_num_proc_num_po select  'EMCSR202006011BR','4005208592'
	insert into #tmp_num_proc_num_po select  'EMCSR202006015BR','4005254837'
	insert into #tmp_num_proc_num_po select  'EMCSR202006016BR','0150724968'
	insert into #tmp_num_proc_num_po select  'EMCSR202006025BR','4005273957'
	insert into #tmp_num_proc_num_po select  'EMCSR202006028BR','4005230049'
	insert into #tmp_num_proc_num_po select  'EMCSR202006029BR','4005230074'
	insert into #tmp_num_proc_num_po select  'EMCSR202006030BR','4005265479'
	insert into #tmp_num_proc_num_po select  'EMCSR202006032BR','4005208906'
	insert into #tmp_num_proc_num_po select  'EMCSR202006034BR','4005208900'
	insert into #tmp_num_proc_num_po select  'EMCSR202006036BR','4005259163'
	insert into #tmp_num_proc_num_po select  'EMCSR202006037BR','4005259157'
	insert into #tmp_num_proc_num_po select  'EMCSR202006040BR','0111223881'
	insert into #tmp_num_proc_num_po select  'EMCSR202006041BR','4005291721'
	insert into #tmp_num_proc_num_po select  'EMCSR202006042BR','4005291723'
	insert into #tmp_num_proc_num_po select  'EMCSR202006024BR','0111244529'
	insert into #tmp_num_proc_num_po select  'EMCSR202006026BR','4005274005'
	insert into #tmp_num_proc_num_po select  'EMCSR202006031BR','4005270891'
	insert into #tmp_num_proc_num_po select  'EMCSR202006033BR','4005208901'
	insert into #tmp_num_proc_num_po select  'EMCSR202006035BR','4005208907'
	insert into #tmp_num_proc_num_po select  'EMCSR202006039BR','4005285035'
	insert into #tmp_num_proc_num_po select  'EMCSR202006044BR','4005259160'
	insert into #tmp_num_proc_num_po select  'EMCSR202006049BR','4005291728'
	insert into #tmp_num_proc_num_po select  'EMCSR202006059BR','4005270743'
	insert into #tmp_num_proc_num_po select  'EMCSR202006060BR','4005270747'
	insert into #tmp_num_proc_num_po select  'EMCSR202006061BR','4005303251'
	insert into #tmp_num_proc_num_po select  'EMCSR202006062BR','4005303238'
	insert into #tmp_num_proc_num_po select  'EMCSR202006070BR','4005224493'
	insert into #tmp_num_proc_num_po select  'EMCSR202006074BR','4005310023'
	insert into #tmp_num_proc_num_po select  'EMCSR202006077BR','4005224499'
	insert into #tmp_num_proc_num_po select  'EMCSR202006078BR','4005260013'
	insert into #tmp_num_proc_num_po select  'EMCSR202006081BR','0111302633'
	insert into #tmp_num_proc_num_po select  'EMCSR202006083BR','0111302034'
	insert into #tmp_num_proc_num_po select  'EMCSR202006088BR','4005259191'
	insert into #tmp_num_proc_num_po select  'EMCSR202006089BR','4005259204'
	insert into #tmp_num_proc_num_po select  'EMCSR202006091BR','4005259180'
	insert into #tmp_num_proc_num_po select  'EMCSR202007008BR','4005321924'
	insert into #tmp_num_proc_num_po select  'EMCSR202007012BR','4005270785'
	insert into #tmp_num_proc_num_po select  'EMCSR202007014BR','4005270889'
	insert into #tmp_num_proc_num_po select  'EMCSR202007016BR','4005318160'
	insert into #tmp_num_proc_num_po select  'EMCSR202007027BR','0111233799'
	insert into #tmp_num_proc_num_po select  'EMCSR202007028BR','4005339186'
	insert into #tmp_num_proc_num_po select  'EMCSR202007029BR','4005336043'
	insert into #tmp_num_proc_num_po select  'EMCSR202007035BR','4005343446'
	insert into #tmp_num_proc_num_po select  'EMCSR202007041BR','4005350709'
	insert into #tmp_num_proc_num_po select  'EMCSR202007052BR','4005328513'
	insert into #tmp_num_proc_num_po select  'EMCSR202007058BR','4005278548'
	insert into #tmp_num_proc_num_po select  'EMCSR202007060BR','4005343448'
	insert into #tmp_num_proc_num_po select  'EMCSR202007061BR','4005326829'
	insert into #tmp_num_proc_num_po select  'EMCSR202007069BR','4005349189'
	insert into #tmp_num_proc_num_po select  'EMCSR202007074BR','0111345111'
	insert into #tmp_num_proc_num_po select  'EMCSR202007075BR','0111345146'
	insert into #tmp_num_proc_num_po select  'EMCSR202007076BR','0111345168'
	insert into #tmp_num_proc_num_po select  'EMCSR202007078BR','0111345124'
	insert into #tmp_num_proc_num_po select  'EMCSR202007082BR','4005380183'
	insert into #tmp_num_proc_num_po select  'EMCSR202007084BR','4005369897'
	insert into #tmp_num_proc_num_po select  'EMCSR202007088BR','4005260014'
	insert into #tmp_num_proc_num_po select  'EMCSR202007089BR','4005260016'
	insert into #tmp_num_proc_num_po select  'EMCSR202007098BR','4005369898'
	insert into #tmp_num_proc_num_po select  'EMCSR202007099BR','4005376724'
	insert into #tmp_num_proc_num_po select  'EMCSR202007100BR','0150743321'
	insert into #tmp_num_proc_num_po select  'EMCSR202008001BR','4005392010'
	insert into #tmp_num_proc_num_po select  'EMCSR202008007BR','4005388178'
	insert into #tmp_num_proc_num_po select  'EMCSR202008008BR','4005379775'
	insert into #tmp_num_proc_num_po select  'EMCSR202008013BR','4005369900'
	insert into #tmp_num_proc_num_po select  'EMCSR202008018BR','4005398879'
	insert into #tmp_num_proc_num_po select  'EMCSR202008019BR','0150745874'
	insert into #tmp_num_proc_num_po select  'EMCSR202008027BR','4005398948'
	insert into #tmp_num_proc_num_po select  'EMCSR202008028BR','4005398960'
	insert into #tmp_num_proc_num_po select  'EMCSR202008025BR','4005398924'
	insert into #tmp_num_proc_num_po select  'EMCSR202008026BR','4005398945'
	insert into #tmp_num_proc_num_po select  'EMCSR202008029BR','4005415588'
	insert into #tmp_num_proc_num_po select  'EMCSR202008037BR','4005318355'
	insert into #tmp_num_proc_num_po select  'EMCSR202008038BR','4005321544'
	insert into #tmp_num_proc_num_po select  'EMCSR202008043BR','4005405547'
	insert into #tmp_num_proc_num_po select  'EMCSR202008046BR','4005369906'
	insert into #tmp_num_proc_num_po select  'EMCSR202008052BR','4005424244'
	insert into #tmp_num_proc_num_po select  'EMCSR202008059BR','4005318361'
	insert into #tmp_num_proc_num_po select  'EMCSR202008061BR','4005364326'
	insert into #tmp_num_proc_num_po select  'EMCSR202008062BR','4005318366'
	insert into #tmp_num_proc_num_po select  'EMCSR202008063BR','4005318367'
	insert into #tmp_num_proc_num_po select  'EMCSR202008066BR','4005356850'
	insert into #tmp_num_proc_num_po select  'EMCSR202008068BR','4005408733'
	insert into #tmp_num_proc_num_po select  'EMCSR202008085BR','4005430418'
	insert into #tmp_num_proc_num_po select  'EMCSR202008089BR','4005369907'
	insert into #tmp_num_proc_num_po select  'EMCSR202008090BR','4005376092'
	insert into #tmp_num_proc_num_po select  'EMCSR202008091BR','4005453123'
	insert into #tmp_num_proc_num_po select  'EMCSR202009001BR','0111475089'
	insert into #tmp_num_proc_num_po select  'EMCSR202009003BR','4005398417'
	insert into #tmp_num_proc_num_po select  'EMCSR202009005BR','4005398422'
	insert into #tmp_num_proc_num_po select  'EMCSR202009006BR','4005398081'
	insert into #tmp_num_proc_num_po select  'EMCSR202009009BR','4005398085'
	insert into #tmp_num_proc_num_po select  'EMCSR202009010BR','4005456201'
	insert into #tmp_num_proc_num_po select  'EMCSR202009012BR','4005466958'
	insert into #tmp_num_proc_num_po select  'EMCSR202009020BR','4005463656'
	insert into #tmp_num_proc_num_po select  'EMCSR202009023BR','4005463662'
	insert into #tmp_num_proc_num_po select  'EMCSR202009027BR','4005458822'
	insert into #tmp_num_proc_num_po select  'EMCSR202009031BR','4005405554'
	insert into #tmp_num_proc_num_po select  'EMCSR202009040BR','0150748588'
	insert into #tmp_num_proc_num_po select  'EMCSR202009041BR','4005438576'
	insert into #tmp_num_proc_num_po select  'EMCSR202009042BR','4005438577'
	insert into #tmp_num_proc_num_po select  'EMCSR202009050BR','4005453035'
	insert into #tmp_num_proc_num_po select  'EMCSR202009054BR','0150745623'
	insert into #tmp_num_proc_num_po select  'EMCSR202009059BR','0150751573'
	insert into #tmp_num_proc_num_po select  'EMCSR202009060BR','0150751574'
	insert into #tmp_num_proc_num_po select  'EMCSR202009062BR','0111516164'
	insert into #tmp_num_proc_num_po select  'EMCSR202009068BR','4005490500'
	insert into #tmp_num_proc_num_po select  'EMCSR202009074BR','0111561278'
	insert into #tmp_num_proc_num_po select  'EMCSR202009079BR','4005505598'
	insert into #tmp_num_proc_num_po select  'EMCSR202009081BR','4005505745'
	insert into #tmp_num_proc_num_po select  'EMCSR202009083BR','4005505767'
	insert into #tmp_num_proc_num_po select  'EMCSR202009090BR','4005499873'
	insert into #tmp_num_proc_num_po select  'EMCSR202009091BR','0150751575'
	insert into #tmp_num_proc_num_po select  'EMCSR202009093BR','0111533967'
	insert into #tmp_num_proc_num_po select  'EMCSR202009097BR','4005512146'
	insert into #tmp_num_proc_num_po select  'EMCSR202010005BR','4005490384'
	insert into #tmp_num_proc_num_po select  'EMCSR202010007BR','4005405904'
	insert into #tmp_num_proc_num_po select  'EMCSR202010013BR','4005505016'
	insert into #tmp_num_proc_num_po select  'EMCSR202010014BR','4005443703'
	insert into #tmp_num_proc_num_po select  'EMCSR202010015BR','4005443708'
	insert into #tmp_num_proc_num_po select  'EMCSR202010017BR','4005504509'
	insert into #tmp_num_proc_num_po select  'EMCSR202010023BR','4005509063'
	insert into #tmp_num_proc_num_po select  'EMCSR202010024BR','0150757855'
	insert into #tmp_num_proc_num_po select  'EMCSR202010027BR','4005476728'
	insert into #tmp_num_proc_num_po select  'EMCSR202008031BR','0150746386'
	insert into #tmp_num_proc_num_po select  'EMCSR202008032BR','4005336085'
	insert into #tmp_num_proc_num_po select  'EMCSR202008040BR','4005405561'
	insert into #tmp_num_proc_num_po select  'EMCSR202008041BR','4005369902'
	insert into #tmp_num_proc_num_po select  'EMCSR202008048BR','4005405552'
	insert into #tmp_num_proc_num_po select  'EMCSR202008050BR','4005413048'
	insert into #tmp_num_proc_num_po select  'EMCSR202008051BR','4005413050'
	insert into #tmp_num_proc_num_po select  'EMCSR202008056BR','4005405903'
	insert into #tmp_num_proc_num_po select  'EMCSR202008058BR','4005423160'
	insert into #tmp_num_proc_num_po select  'EMCSR202008060BR','0150741583'
	insert into #tmp_num_proc_num_po select  'EMCSR202008065BR','4005321561'
	insert into #tmp_num_proc_num_po select  'EMCSR202008067BR','4005397918'
	insert into #tmp_num_proc_num_po select  'EMCSR202008069BR','0111446262'
	insert into #tmp_num_proc_num_po select  'EMCSR202008070BR','4005432300'
	insert into #tmp_num_proc_num_po select  'EMCSR202008071BR','4005433735'
	insert into #tmp_num_proc_num_po select  'EMCSR202008072BR','4005430538'
	insert into #tmp_num_proc_num_po select  'EMCSR202008074BR','4005423819'
	insert into #tmp_num_proc_num_po select  'EMCSR202008076BR','4005423823'
	insert into #tmp_num_proc_num_po select  'EMCSR202008080BR','0111475047'
	insert into #tmp_num_proc_num_po select  'EMCSR202008082BR','4005412446'
	insert into #tmp_num_proc_num_po select  'EMCSR202008087BR','0111488002'
	insert into #tmp_num_proc_num_po select  'EMCSR202008095BR','4005397947'
	insert into #tmp_num_proc_num_po select  'EMCSR202008097BR','4005448132'
	insert into #tmp_num_proc_num_po select  'EMCSR202009004BR','4005398420'
	insert into #tmp_num_proc_num_po select  'EMCSR202009007BR','4005398631'
	insert into #tmp_num_proc_num_po select  'EMCSR202009008BR','4005398084'
	insert into #tmp_num_proc_num_po select  'EMCSR202009013BR','4005456219'
	insert into #tmp_num_proc_num_po select  'EMCSR202009015BR','4005442733'
	insert into #tmp_num_proc_num_po select  'EMCSR202009017BR','4005444400'
	insert into #tmp_num_proc_num_po select  'EMCSR202009021BR','4005463657'
	insert into #tmp_num_proc_num_po select  'EMCSR202009026BR','4005458759'
	insert into #tmp_num_proc_num_po select  'EMCSR202009030BR','4005405557'
	insert into #tmp_num_proc_num_po select  'EMCSR202009032BR','0150748032'
	insert into #tmp_num_proc_num_po select  'EMCSR202009035BR','0150748137'
	insert into #tmp_num_proc_num_po select  'EMCSR202009037BR','0111469511'
	insert into #tmp_num_proc_num_po select  'EMCSR202009039BR','0111556812'
	insert into #tmp_num_proc_num_po select  'EMCSR202009043BR','4005463655'
	insert into #tmp_num_proc_num_po select  'EMCSR202009044BR','4005443493'
	insert into #tmp_num_proc_num_po select  'EMCSR202009045BR','4005452071'
	insert into #tmp_num_proc_num_po select  'EMCSR202009046BR','0150751141'
	insert into #tmp_num_proc_num_po select  'EMCSR202009048BR','4005443511'
	insert into #tmp_num_proc_num_po select  'EMCSR202009049BR','4005443513'
	insert into #tmp_num_proc_num_po select  'EMCSR202009051BR','4005473646'
	insert into #tmp_num_proc_num_po select  'EMCSR202009052BR','0111544969'
	insert into #tmp_num_proc_num_po select  'EMCSR202009061BR','4005412724'
	insert into #tmp_num_proc_num_po select  'EMCSR202009063BR','4005470311'
	insert into #tmp_num_proc_num_po select  'EMCSR202009064BR','4005503238'
	insert into #tmp_num_proc_num_po select  'EMCSR202009065BR','4005463733'
	insert into #tmp_num_proc_num_po select  'EMCSR202009066BR','4005505781'
	insert into #tmp_num_proc_num_po select  'EMCSR202009069BR','4005490080'
	insert into #tmp_num_proc_num_po select  'EMCSR202009072BR','0150755465'
	insert into #tmp_num_proc_num_po select  'EMCSR202009075BR','4005505590'
	insert into #tmp_num_proc_num_po select  'EMCSR202009076BR','4005444396'
	insert into #tmp_num_proc_num_po select  'EMCSR202009077BR','4005497095'
	insert into #tmp_num_proc_num_po select  'EMCSR202009078BR','4005505594'
	insert into #tmp_num_proc_num_po select  'EMCSR202009085BR','4005453432'
	insert into #tmp_num_proc_num_po select  'EMCSR202009087BR','4005448100'
	insert into #tmp_num_proc_num_po select  'EMCSR202009089BR','4005376099'
	insert into #tmp_num_proc_num_po select  'EMCSR202009095BR','4005466960'
	insert into #tmp_num_proc_num_po select  'EMCSR202010001BR','4005499858'
	insert into #tmp_num_proc_num_po select  'EMCSR202010003BR','4005518456'
	insert into #tmp_num_proc_num_po select  'EMCSR202010004BR','4005398753'
	insert into #tmp_num_proc_num_po select  'EMCSR202010006BR','4005452077'
	insert into #tmp_num_proc_num_po select  'EMCSR202010008BR','4005504475'
	insert into #tmp_num_proc_num_po select  'EMCSR202010009BR','4005502997'
	insert into #tmp_num_proc_num_po select  'EMCSR202010011BR','4005503032'
	insert into #tmp_num_proc_num_po select  'EMCSR202010018BR','4005504511'
	insert into #tmp_num_proc_num_po select  'EMCSR202010025BR','0111623469'
	insert into #tmp_num_proc_num_po select  'EMCSR202010030BR','4005475526'
	insert into #tmp_num_proc_num_po select  'EMCSR202010036BR','4005503148'
	insert into #tmp_num_proc_num_po select  'EMCSR202010037BR','4005518130'
	insert into #tmp_num_proc_num_po select  'EMCSR202010038BR','4005538771'
	insert into #tmp_num_proc_num_po select  'EMCSR202010042BR','4005529434'
	insert into #tmp_num_proc_num_po select  'EMCSR202010043BR','4005536939'
	insert into #tmp_num_proc_num_po select  'EMCSR202010045BR','0150752302'
	insert into #tmp_num_proc_num_po select  'EMCSR202010048BR','0150752305'
	insert into #tmp_num_proc_num_po select  'EMCSR202010049BR','4005473755'
	insert into #tmp_num_proc_num_po select  'EMCSR202010050BR','4005529443'
	insert into #tmp_num_proc_num_po select  'EMCSR202010053BR','4005565369'
	insert into #tmp_num_proc_num_po select  'EMCSR202010055BR','4005565385'
	insert into #tmp_num_proc_num_po select  'EMCSR202010056BR','4005565392'
	insert into #tmp_num_proc_num_po select  'EMCSR202010058BR','4005476724'
	insert into #tmp_num_proc_num_po select  'EMCSR202010064BR','4005369905'
	insert into #tmp_num_proc_num_po select  'EMCSR202010066BR','4005505666'
	insert into #tmp_num_proc_num_po select  'EMCSR202010068BR','4005505664'
	insert into #tmp_num_proc_num_po select  'EMCSR202010070BR','4005546588'
	insert into #tmp_num_proc_num_po select  'EMCSR202010086BR','0150761213'
	insert into #tmp_num_proc_num_po select  'EMCSR202010089BR','0150761217'
	insert into #tmp_num_proc_num_po select  'EMCSR202010090BR','4005531828'
	insert into #tmp_num_proc_num_po select  'EMCSR202010093BR','4005505622'
	insert into #tmp_num_proc_num_po select  'EMCSR202010094BR','0111715537'
	insert into #tmp_num_proc_num_po select  'EMCSR202010097BR','4005548713'
	insert into #tmp_num_proc_num_po select  'EMCSR202010103BR','4005476758'
	insert into #tmp_num_proc_num_po select  'EMCSR202010104BR','4005476745'
	insert into #tmp_num_proc_num_po select  'EMCSR202010106BR','0111619148'
	insert into #tmp_num_proc_num_po select  'EMCSR202010107BR','4005571982'
	insert into #tmp_num_proc_num_po select  'EMCSR202010110BR','0150752030'
	insert into #tmp_num_proc_num_po select  'EMCSR202011001BR','4005476751'
	insert into #tmp_num_proc_num_po select  'EMCSR202011003BR','4005554401'
	insert into #tmp_num_proc_num_po select  'EMCSR202011009BR','4005554410'
	insert into #tmp_num_proc_num_po select  'EMCSR202011010BR','4005554469'
	insert into #tmp_num_proc_num_po select  'EMCSR202011021BR','4005593066'
	insert into #tmp_num_proc_num_po select  'EMCSR202011027BR','0111781412'
	insert into #tmp_num_proc_num_po select  'EMCSR202011034BR','0150761230'
	insert into #tmp_num_proc_num_po select  'EMCSR202011035BR','0150761232'
	insert into #tmp_num_proc_num_po select  'EMCSR202011043BR','0111663931'
	insert into #tmp_num_proc_num_po select  'EMCSR202011045BR','4005476754'
	insert into #tmp_num_proc_num_po select  'EMCSR202011046BR','4005568941'
	insert into #tmp_num_proc_num_po select  'EMCSR202011048BR','4005466965'
	insert into #tmp_num_proc_num_po select  'EMCSR202011050BR','4005476765'
	insert into #tmp_num_proc_num_po select  'EMCSR202011051BR','4005490523'
	insert into #tmp_num_proc_num_po select  'EMCSR202006043BR','4005291855'
	insert into #tmp_num_proc_num_po select  'EMCSR202006045BR','4005259156'
	insert into #tmp_num_proc_num_po select  'EMCSR202006046BR','0111244554'
	insert into #tmp_num_proc_num_po select  'EMCSR202006054BR','4005282772'
	insert into #tmp_num_proc_num_po select  'EMCSR202006057BR','4005270752'
	insert into #tmp_num_proc_num_po select  'EMCSR202006058BR','4005270735'
	insert into #tmp_num_proc_num_po select  'EMCSR202006063BR','4005308235'
	insert into #tmp_num_proc_num_po select  'EMCSR202006064BR','0150732276'
	insert into #tmp_num_proc_num_po select  'EMCSR202006065BR','4005282200'
	insert into #tmp_num_proc_num_po select  'EMCSR202006066BR','4005303245'
	insert into #tmp_num_proc_num_po select  'EMCSR202006069BR','4005224489'
	insert into #tmp_num_proc_num_po select  'EMCSR202006071BR','0150735263'
	insert into #tmp_num_proc_num_po select  'EMCSR202006080BR','0111302694'
	insert into #tmp_num_proc_num_po select  'EMCSR202006082BR','0111302073'
	insert into #tmp_num_proc_num_po select  'EMCSR202006084BR','0111301971'
	insert into #tmp_num_proc_num_po select  'EMCSR202006085BR','0111249243'
	insert into #tmp_num_proc_num_po select  'EMCSR202006090BR','4005259167'
	insert into #tmp_num_proc_num_po select  'EMCSR202006092BR','4005259206'
	insert into #tmp_num_proc_num_po select  'EMCSR202007001BR','4005209452'
	insert into #tmp_num_proc_num_po select  'EMCSR202007002BR','4005311265'
	insert into #tmp_num_proc_num_po select  'EMCSR202007004BR','4005290040'
	insert into #tmp_num_proc_num_po select  'EMCSR202007005BR','4005329523'
	insert into #tmp_num_proc_num_po select  'EMCSR202007007BR','4005321923'
	insert into #tmp_num_proc_num_po select  'EMCSR202007009BR','4005321925'
	insert into #tmp_num_proc_num_po select  'EMCSR202007010BR','4005321926'
	insert into #tmp_num_proc_num_po select  'EMCSR202007017BR','4005318170'
	insert into #tmp_num_proc_num_po select  'EMCSR202007018BR','4005318173'
	insert into #tmp_num_proc_num_po select  'EMCSR202007019BR','4005267134'
	insert into #tmp_num_proc_num_po select  'EMCSR202007020BR','4005267122'
	insert into #tmp_num_proc_num_po select  'EMCSR202007021BR','4005267519'
	insert into #tmp_num_proc_num_po select  'EMCSR202007022BR','4005323444'
	insert into #tmp_num_proc_num_po select  'EMCSR202007023BR','4005335983'
	insert into #tmp_num_proc_num_po select  'EMCSR202007024BR','4005332784'
	insert into #tmp_num_proc_num_po select  'EMCSR202007025BR','4005327010'
	insert into #tmp_num_proc_num_po select  'EMCSR202007026BR','4005334122'
	insert into #tmp_num_proc_num_po select  'EMCSR202007030BR','4005336046'
	insert into #tmp_num_proc_num_po select  'EMCSR202007032BR','4005336048'
	insert into #tmp_num_proc_num_po select  'EMCSR202007033BR','4005323272'
	insert into #tmp_num_proc_num_po select  'EMCSR202007034BR','4005336033'
	insert into #tmp_num_proc_num_po select  'EMCSR202007036BR','4005318166'
	insert into #tmp_num_proc_num_po select  'EMCSR202007037BR','4005343148'
	insert into #tmp_num_proc_num_po select  'EMCSR202007038BR','4005346665'
	insert into #tmp_num_proc_num_po select  'EMCSR202007040BR','4005350612'
	insert into #tmp_num_proc_num_po select  'EMCSR202007042BR','4005305637'
	insert into #tmp_num_proc_num_po select  'EMCSR202007046BR','4005321540'
	insert into #tmp_num_proc_num_po select  'EMCSR202007054BR','4005328524'
	insert into #tmp_num_proc_num_po select  'EMCSR202007055BR','4005328531'
	insert into #tmp_num_proc_num_po select  'EMCSR202007057BR','0111302794'
	insert into #tmp_num_proc_num_po select  'EMCSR202007059BR','4005356848'
	insert into #tmp_num_proc_num_po select  'EMCSR202007062BR','4005326830'
	insert into #tmp_num_proc_num_po select  'EMCSR202007064BR','4005335977'
	insert into #tmp_num_proc_num_po select  'EMCSR202007066BR','4005346455'
	insert into #tmp_num_proc_num_po select  'EMCSR202007067BR','0150741227'
	insert into #tmp_num_proc_num_po select  'EMCSR202007072BR','4005358910'
	insert into #tmp_num_proc_num_po select  'EMCSR202007077BR','0111343909'
	insert into #tmp_num_proc_num_po select  'EMCSR202010029BR','0111587388'
	insert into #tmp_num_proc_num_po select  'EMCSR202010031BR','4005451569'
	insert into #tmp_num_proc_num_po select  'EMCSR202010033BR','0111608051'
	insert into #tmp_num_proc_num_po select  'EMCSR202010034BR','4005528623'
	insert into #tmp_num_proc_num_po select  'EMCSR202010039BR','4005532646'
	insert into #tmp_num_proc_num_po select  'EMCSR202010046BR','150752304'
	insert into #tmp_num_proc_num_po select  'EMCSR202010054BR','4005565382'
	insert into #tmp_num_proc_num_po select  'EMCSR202010057BR','0150752306'
	insert into #tmp_num_proc_num_po select  'EMCSR202010059BR','0150757299'
	insert into #tmp_num_proc_num_po select  'EMCSR202010060BR','4005529306'
	insert into #tmp_num_proc_num_po select  'EMCSR202010069BR','4005499861'
	insert into #tmp_num_proc_num_po select  'EMCSR202010074BR','4005602330'
	insert into #tmp_num_proc_num_po select  'EMCSR202010078BR','4005480988'
	insert into #tmp_num_proc_num_po select  'EMCSR202010083BR','4005504504'
	insert into #tmp_num_proc_num_po select  'EMCSR202010088BR','0150761215'
	insert into #tmp_num_proc_num_po select  'EMCSR202010092BR','4005551592'
	insert into #tmp_num_proc_num_po select  'EMCSR202010099BR','0150763201'
	insert into #tmp_num_proc_num_po select  'EMCSR202010100BR','150763206'
	insert into #tmp_num_proc_num_po select  'EMCSR202010101BR','4005582904'
	insert into #tmp_num_proc_num_po select  'EMCSR202010109BR','4005519745'
	insert into #tmp_num_proc_num_po select  'EMCSR202010111BR','4005579490'
	insert into #tmp_num_proc_num_po select  'EMCSR202010112BR','0150756994'
	insert into #tmp_num_proc_num_po select  'EMCSR202010113BR','0150762019'
	insert into #tmp_num_proc_num_po select  'EMCSR202010114BR','4005490747'
	insert into #tmp_num_proc_num_po select  'EMCSR202011002BR','4005598423'
	insert into #tmp_num_proc_num_po select  'EMCSR202011004BR','4005554404'
	insert into #tmp_num_proc_num_po select  'EMCSR202011006BR','4005591940'
	insert into #tmp_num_proc_num_po select  'EMCSR202011007BR','4005551417'
	insert into #tmp_num_proc_num_po select  'EMCSR202011012BR','4005554517'
	insert into #tmp_num_proc_num_po select  'EMCSR202011014BR','4005592903'
	insert into #tmp_num_proc_num_po select  'EMCSR202011015BR','4005554043'
	insert into #tmp_num_proc_num_po select  'EMCSR202011017BR','4005505667'
	insert into #tmp_num_proc_num_po select  'EMCSR202011025BR','0111674182'
	insert into #tmp_num_proc_num_po select  'EMCSR202011026BR','4005538272'
	insert into #tmp_num_proc_num_po select  'EMCSR202011028BR','4005598443'
	insert into #tmp_num_proc_num_po select  'EMCSR202011030BR','0111726481'
	insert into #tmp_num_proc_num_po select  'EMCSR202011037BR','0150761234'
	insert into #tmp_num_proc_num_po select  'EMCSR202011038BR','0150761235'
	insert into #tmp_num_proc_num_po select  'EMCSR202011042BR','0111743711'
	insert into #tmp_num_proc_num_po select  'EMCSR202011062BR','4005615387'
	insert into #tmp_num_proc_num_po select  'EMCSR202011064BR','4005627825'
	insert into #tmp_num_proc_num_po select  'EMCSR202011065BR','4005615631'
	insert into #tmp_num_proc_num_po select  'EMCSR202011067BR','4005615647'
	insert into #tmp_num_proc_num_po select  'EMCSR202011070BR','4005603997'
	insert into #tmp_num_proc_num_po select  'EMCSR202011074BR','0111787708'
	insert into #tmp_num_proc_num_po select  'EMCSR202011080BR','4005554799'
	insert into #tmp_num_proc_num_po select  'EMCSR202011081BR','4005562427'
	insert into #tmp_num_proc_num_po select  'EMCSR202011089BR','4005611938'
	insert into #tmp_num_proc_num_po select  'EMCSR202011093BR','4005638098'
	insert into #tmp_num_proc_num_po select  'EMCSR202011095BR','4005611940'
	insert into #tmp_num_proc_num_po select  'EMCSR202011098BR','4005610084'
	insert into #tmp_num_proc_num_po select  'EMCSR202011100BR','4005610088'
	insert into #tmp_num_proc_num_po select  'EMCSR202011110BR','4005605747'
	insert into #tmp_num_proc_num_po select  'EMCSR202011113BR','4005605754'
	insert into #tmp_num_proc_num_po select  'EMCSR202011120BR','4005675875'
	insert into #tmp_num_proc_num_po select  'EMCSR202011054BR','4005554582'
	insert into #tmp_num_proc_num_po select  'EMCSR202011055BR','0150763124'
	insert into #tmp_num_proc_num_po select  'EMCSR202011057BR','4005592040'
	insert into #tmp_num_proc_num_po select  'EMCSR202011060BR','4005615383'
	insert into #tmp_num_proc_num_po select  'EMCSR202011066BR','4005615644'
	insert into #tmp_num_proc_num_po select  'EMCSR202011079BR','0111734442'
	insert into #tmp_num_proc_num_po select  'EMCSR202011083BR','0111810383'
	insert into #tmp_num_proc_num_po select  'EMCSR202011084BR','0111803872'
	insert into #tmp_num_proc_num_po select  'EMCSR202011086BR','4005490527'
	insert into #tmp_num_proc_num_po select  'EMCSR202011104BR','4005640249'
	insert into #tmp_num_proc_num_po select  'EMCSR202011114BR','0111843471'
	insert into #tmp_num_proc_num_po select  'EMCSR202011118BR','4005650735'
	insert into #tmp_num_proc_num_po select  'EMCSR202011121BR','4005650773'
	insert into #tmp_num_proc_num_po select  'EMCSR202011125BR','4005627294'
	insert into #tmp_num_proc_num_po select  'EMCSR202011135BR','0150763208'
	insert into #tmp_num_proc_num_po select  'EMCSR202011137BR','0111895312'
	insert into #tmp_num_proc_num_po select  'EMCSR202012008BR','4005683199'
	insert into #tmp_num_proc_num_po select  'EMCSR202012010BR','111885788'
	insert into #tmp_num_proc_num_po select  'EMCSR202012012BR','4005698372'
	insert into #tmp_num_proc_num_po select  'EMCSR202012013BR','4005698373'
	insert into #tmp_num_proc_num_po select  'EMCSR202012014BR','0111771028'
	insert into #tmp_num_proc_num_po select  'EMCSR202012019BR','0111771099'
	insert into #tmp_num_proc_num_po select  'EMCSR202012022BR','0111771576'
	insert into #tmp_num_proc_num_po select  'EMCSR202012029BR','0111873884'
	insert into #tmp_num_proc_num_po select  'EMCSR202012036BR','0150763131'
	insert into #tmp_num_proc_num_po select  'EMCSR202012040BR','0150763129'
	insert into #tmp_num_proc_num_po select  'EMCSR202012046BR','4005709207'
	insert into #tmp_num_proc_num_po select  'EMCSR202012090BR','0111984766'
	insert into #tmp_num_proc_num_po select  'EOCSR201912008BR','0150670906'
	insert into #tmp_num_proc_num_po select  'EOCSR201912010BR','4004548156'
	insert into #tmp_num_proc_num_po select  'EOCSR202001011BR','0150689692'
	insert into #tmp_num_proc_num_po select  'EOCSR202001017BR','0150698487'
	insert into #tmp_num_proc_num_po select  'EOCSR202002001BR','150700803'
	insert into #tmp_num_proc_num_po select  'EOCSR202002004BR','0150689693'
	insert into #tmp_num_proc_num_po select  'EOCSR202002007BR','0150698488'
	insert into #tmp_num_proc_num_po select  'EOCSR202004003BR','4005140603'
	insert into #tmp_num_proc_num_po select  'EOCSR202005007BR','150724045'
	insert into #tmp_num_proc_num_po select  'EOCSR202006003BR','4005257251'
	insert into #tmp_num_proc_num_po select  'EOCSR202006008BR','0150704902'
	insert into #tmp_num_proc_num_po select  'EOCSR202006009BR','111222467'
	insert into #tmp_num_proc_num_po select  'EOCSR202007002BR','0150713868'
	insert into #tmp_num_proc_num_po select  'EOCSR202007004BR','4005339526'
	insert into #tmp_num_proc_num_po select  'EOCSR202007009BR','4005349762'
	insert into #tmp_num_proc_num_po select  'EOCSR202007010BR','4005349794'
	insert into #tmp_num_proc_num_po select  'EOCSR202007011BR','4005349816'
	insert into #tmp_num_proc_num_po select  'EOCSR202007013BR','4005339513'
	insert into #tmp_num_proc_num_po select  'EOCSR202007021BR','0150713935'
	insert into #tmp_num_proc_num_po select  'EOCSR202007027BR','4005365332'
	insert into #tmp_num_proc_num_po select  'EOCSR202007029BR','4005374171'
	insert into #tmp_num_proc_num_po select  'EOCSR202007030BR','4005374172'
	insert into #tmp_num_proc_num_po select  'EOCSR202007034BR','4005374198'
	insert into #tmp_num_proc_num_po select  'EOCSR202007035BR','4005374262'
	insert into #tmp_num_proc_num_po select  'EOCSR202007037BR','4005374270'
	insert into #tmp_num_proc_num_po select  'EOCSR202007042BR','4005374320'
	insert into #tmp_num_proc_num_po select  'EOCSR202007045BR','4005365252'
	insert into #tmp_num_proc_num_po select  'EOCSR202007046BR','4005365250'
	insert into #tmp_num_proc_num_po select  'EMCSR202007096BR','4005224427'
	insert into #tmp_num_proc_num_po select  'EMCSR202007097BR','4005247667'
	insert into #tmp_num_proc_num_po select  'EMCSR202008002BR','4005392012'
	insert into #tmp_num_proc_num_po select  'EMCSR202008005BR','0150736487'
	insert into #tmp_num_proc_num_po select  'EMCSR202008009BR','4005376808'
	insert into #tmp_num_proc_num_po select  'EMCSR202008014BR','4005369901'
	insert into #tmp_num_proc_num_po select  'EMCSR202008017BR','4005398856'
	insert into #tmp_num_proc_num_po select  'EMCSR202008030BR','4005415605'
	insert into #tmp_num_proc_num_po select  'EMCSR202008034BR','0111440551'
	insert into #tmp_num_proc_num_po select  'EMCSR202008035BR','4005415824'
	insert into #tmp_num_proc_num_po select  'EMCSR202008036BR','4005418850'
	insert into #tmp_num_proc_num_po select  'EMCSR202008039BR','4005405549'
	insert into #tmp_num_proc_num_po select  'EMCSR202008049BR','4005413025'
	insert into #tmp_num_proc_num_po select  'EMCSR202008053BR','4005424247'
	insert into #tmp_num_proc_num_po select  'EMCSR202008054BR','4005424252'
	insert into #tmp_num_proc_num_po select  'EMCSR202008055BR','4005424271'
	insert into #tmp_num_proc_num_po select  'EMCSR202008057BR','4005424810'
	insert into #tmp_num_proc_num_po select  'EMCSR202008064BR','4005321558'
	insert into #tmp_num_proc_num_po select  'EMCSR202008073BR','4005224429'
	insert into #tmp_num_proc_num_po select  'EMCSR202008075BR','4005423820'
	insert into #tmp_num_proc_num_po select  'EMCSR202008079BR','4005402317'
	insert into #tmp_num_proc_num_po select  'EMCSR202008081BR','0111461536'
	insert into #tmp_num_proc_num_po select  'EMCSR202008083BR','4005328542'
	insert into #tmp_num_proc_num_po select  'EMCSR202008084BR','4005398753'
	insert into #tmp_num_proc_num_po select  'EMCSR202008086BR','4005436199'
	insert into #tmp_num_proc_num_po select  'EMCSR202008088BR','4005376889'
	insert into #tmp_num_proc_num_po select  'EMCSR202008092BR','4005398627'
	insert into #tmp_num_proc_num_po select  'EMCSR202008096BR','4005398079'
	insert into #tmp_num_proc_num_po select  'EMCSR202009002BR','4005398410'
	insert into #tmp_num_proc_num_po select  'EMCSR202009011BR','4005402622'
	insert into #tmp_num_proc_num_po select  'EMCSR202009014BR','4005456221'
	insert into #tmp_num_proc_num_po select  'EMCSR202009016BR','4005456214'
	insert into #tmp_num_proc_num_po select  'EMCSR202009018BR','4005458919'
	insert into #tmp_num_proc_num_po select  'EMCSR202009019BR','4005463677'
	insert into #tmp_num_proc_num_po select  'EMCSR202009022BR','4005463660'
	insert into #tmp_num_proc_num_po select  'EMCSR202009024BR','4005398967'
	insert into #tmp_num_proc_num_po select  'EMCSR202009025BR','4005458754'
	insert into #tmp_num_proc_num_po select  'EMCSR202009033BR','0150748135'
	insert into #tmp_num_proc_num_po select  'EMCSR202009034BR','0150748136'
	insert into #tmp_num_proc_num_po select  'EMCSR202009036BR','0111456782'
	insert into #tmp_num_proc_num_po select  'EMCSR202009047BR','4005443504'
	insert into #tmp_num_proc_num_po select  'EMCSR202009057BR','4005484428'
	insert into #tmp_num_proc_num_po select  'EMCSR202009058BR','0150751572'
	insert into #tmp_num_proc_num_po select  'EMCSR202009067BR','4005467244'
	insert into #tmp_num_proc_num_po select  'EMCSR202009070BR','0150755492'
	insert into #tmp_num_proc_num_po select  'EMCSR202009071BR','4005418855'
	insert into #tmp_num_proc_num_po select  'EMCSR202009073BR','4005438578'
	insert into #tmp_num_proc_num_po select  'EMCSR202009080BR','4005505601'
	insert into #tmp_num_proc_num_po select  'EMCSR202009082BR','4005505755'
	insert into #tmp_num_proc_num_po select  'EMCSR202009084BR','4005505775'
	insert into #tmp_num_proc_num_po select  'EMCSR202009086BR','4005466399'
	insert into #tmp_num_proc_num_po select  'EMCSR202009088BR','4005466973'
	insert into #tmp_num_proc_num_po select  'EMCSR202009092BR','0150754969'
	insert into #tmp_num_proc_num_po select  'EMCSR202009094BR','0150754043'
	insert into #tmp_num_proc_num_po select  'EMCSR202009096BR','4005476722'
	insert into #tmp_num_proc_num_po select  'EMCSR202010002BR','4005512409'
	insert into #tmp_num_proc_num_po select  'EMCSR202011124BR','4005650781'
	insert into #tmp_num_proc_num_po select  'EMCSR202011126BR','0111862200'
	insert into #tmp_num_proc_num_po select  'EMCSR202011127BR','0150771969'
	insert into #tmp_num_proc_num_po select  'EMCSR202011128BR','4005675786'
	insert into #tmp_num_proc_num_po select  'EMCSR202011131BR','4005650782'
	insert into #tmp_num_proc_num_po select  'EMCSR202012004BR','4005661578'
	insert into #tmp_num_proc_num_po select  'EMCSR202012007BR','4005490557'
	insert into #tmp_num_proc_num_po select  'EMCSR202012016BR','4005698848'
	insert into #tmp_num_proc_num_po select  'EMCSR202012017BR','0111771072'
	insert into #tmp_num_proc_num_po select  'EMCSR202012023BR','0111771557'
	insert into #tmp_num_proc_num_po select  'EMCSR202012026BR','4005682725'
	insert into #tmp_num_proc_num_po select  'EMCSR202012027BR','4005682728'
	insert into #tmp_num_proc_num_po select  'EMCSR202012028BR','4005682729'
	insert into #tmp_num_proc_num_po select  'EMCSR202012039BR','0150763130'
	insert into #tmp_num_proc_num_po select  'EMCSR202012048BR','0111907335'
	insert into #tmp_num_proc_num_po select  'EMCSR202012051BR','4005689848'
	insert into #tmp_num_proc_num_po select  'EMCSR202012063BR','4005702071'
	insert into #tmp_num_proc_num_po select  'EOCSR201912009BR','4004832358'
	insert into #tmp_num_proc_num_po select  'EOCSR202001002BR','0150690247'
	insert into #tmp_num_proc_num_po select  'EOCSR202001003BR','4004864904'
	insert into #tmp_num_proc_num_po select  'EOCSR202001005BR','4004864896'
	insert into #tmp_num_proc_num_po select  'EOCSR202001006BR','4004901761'
	insert into #tmp_num_proc_num_po select  'EOCSR202001012BR','150698510'
	insert into #tmp_num_proc_num_po select  'EOCSR202001014BR','0110695120'
	insert into #tmp_num_proc_num_po select  'EOCSR202002002BR','150698511'
	insert into #tmp_num_proc_num_po select  'EOCSR202002003BR','0150704900'
	insert into #tmp_num_proc_num_po select  'EOCSR202003002BR','4005056349'
	insert into #tmp_num_proc_num_po select  'EOCSR202003005BR','150705980'
	insert into #tmp_num_proc_num_po select  'EOCSR202003006BR','0150707579'
	insert into #tmp_num_proc_num_po select  'EOCSR202003007BR','4005026287'
	insert into #tmp_num_proc_num_po select  'EOCSR202003009BR','4005047335'
	insert into #tmp_num_proc_num_po select  'EOCSR202003011BR','0150711923'
	insert into #tmp_num_proc_num_po select  'EOCSR202003013BR','4005076695'
	insert into #tmp_num_proc_num_po select  'EOCSR202004002BR','4005151621'
	insert into #tmp_num_proc_num_po select  'EOCSR202004004BR','0150722928'
	insert into #tmp_num_proc_num_po select  'EOCSR202004005BR','0150719332'
	insert into #tmp_num_proc_num_po select  'EOCSR202005002BR','0111106543'
	insert into #tmp_num_proc_num_po select  'EOCSR202005004BR','150689696'
	insert into #tmp_num_proc_num_po select  'EOCSR202006005BR','4005291615'
	insert into #tmp_num_proc_num_po select  'EOCSR202006006BR','0150713874'
	insert into #tmp_num_proc_num_po select  'EOCSR202006007BR','0150713934'
	insert into #tmp_num_proc_num_po select  'EOCSR202007001BR','4005303778'
	insert into #tmp_num_proc_num_po select  'EOCSR202007003BR','0150713869'
	insert into #tmp_num_proc_num_po select  'EOCSR202007005BR','4005342853'
	insert into #tmp_num_proc_num_po select  'EOCSR202007006BR','4005349703'
	insert into #tmp_num_proc_num_po select  'EOCSR202007014BR','4005339508'
	insert into #tmp_num_proc_num_po select  'EOCSR202007015BR','4005339506'
	insert into #tmp_num_proc_num_po select  'EOCSR202007016BR','4005343352'
	insert into #tmp_num_proc_num_po select  'EOCSR202007019BR','0150689695'
	insert into #tmp_num_proc_num_po select  'EOCSR202007020BR','0150738453'
	insert into #tmp_num_proc_num_po select  'EOCSR202007024BR','4005365312'
	insert into #tmp_num_proc_num_po select  'EOCSR202007031BR','4005374175'
	insert into #tmp_num_proc_num_po select  'EOCSR202007033BR','4005374194'
	insert into #tmp_num_proc_num_po select  'EOCSR202007039BR','4005374315'
	insert into #tmp_num_proc_num_po select  'EOCSR202007040BR','4005374318'
	insert into #tmp_num_proc_num_po select  'EOCSR202007043BR','4005374321'
	insert into #tmp_num_proc_num_po select  'EOCSR202007049BR','4005359882'
	insert into #tmp_num_proc_num_po select  'EOCSR202008009BR','0111408806'
	insert into #tmp_num_proc_num_po select  'EOCSR202008010BR','0150740767'
	insert into #tmp_num_proc_num_po select  'EOCSR202008011BR','4005406054'
	insert into #tmp_num_proc_num_po select  'EOCSR202008015BR','4005413344'
	insert into #tmp_num_proc_num_po select  'EOCSR202008016BR','4005413362'
	insert into #tmp_num_proc_num_po select  'EOCSR202008021BR','0150743420'
	insert into #tmp_num_proc_num_po select  'EOCSR202008028BR','0150746173'
	insert into #tmp_num_proc_num_po select  'EOCSR202008031BR','0150743427'
	insert into #tmp_num_proc_num_po select  'EOCSR202009001BR','0150747644'
	insert into #tmp_num_proc_num_po select  'EOCSR202010001BR','0150753336'
	insert into #tmp_num_proc_num_po select  'EOCSR202010007BR','0150756286'
	insert into #tmp_num_proc_num_po select  'EOCSR202010009BR','0150758638'
	insert into #tmp_num_proc_num_po select  'EOCSR202010010BR','0111613920'
	insert into #tmp_num_proc_num_po select  'EOCSR202010012BR','0150762964'
	insert into #tmp_num_proc_num_po select  'EOCSR202010013BR','150762920'
	insert into #tmp_num_proc_num_po select  'EOCSR202011002BR','4005577225'
	insert into #tmp_num_proc_num_po select  'EOCSR202011010BR','4005644382'
	insert into #tmp_num_proc_num_po select  'EOCSR202011012BR','0150762921'
	insert into #tmp_num_proc_num_po select  'EOCSR202011017BR','4005638104'
	insert into #tmp_num_proc_num_po select  'EOCSR202012003BR','0150762923'
	insert into #tmp_num_proc_num_po select  'EOCSR202103024BR','111656217'
	insert into #tmp_num_proc_num_po select  'EMCSR202010010BR','4005503012'
	insert into #tmp_num_proc_num_po select  'EMCSR202010012BR','4005503037'
	insert into #tmp_num_proc_num_po select  'EMCSR202010016BR','4005504506'
	insert into #tmp_num_proc_num_po select  'EMCSR202010019BR','4005504514'
	insert into #tmp_num_proc_num_po select  'EMCSR202010020BR','0111550758'
	insert into #tmp_num_proc_num_po select  'EMCSR202010022BR','4005481446'
	insert into #tmp_num_proc_num_po select  'EMCSR202010026BR','4005499431'
	insert into #tmp_num_proc_num_po select  'EMCSR202010028BR','0111587210'
	insert into #tmp_num_proc_num_po select  'EMCSR202010032BR','4005484425'
	insert into #tmp_num_proc_num_po select  'EMCSR202010035BR','4005528618'
	insert into #tmp_num_proc_num_po select  'EMCSR202010040BR','4005528947'
	insert into #tmp_num_proc_num_po select  'EMCSR202010041BR','4005529388'
	insert into #tmp_num_proc_num_po select  'EMCSR202010044BR','4005481108'
	insert into #tmp_num_proc_num_po select  'EMCSR202010051BR','4005529451'
	insert into #tmp_num_proc_num_po select  'EMCSR202010052BR','4005529456'
	insert into #tmp_num_proc_num_po select  'EMCSR202010061BR','4005529460'
	insert into #tmp_num_proc_num_po select  'EMCSR202010062BR','4005529369'
	insert into #tmp_num_proc_num_po select  'EMCSR202010063BR','4005484412'
	insert into #tmp_num_proc_num_po select  'EMCSR202010067BR','4005505657'
	insert into #tmp_num_proc_num_po select  'EMCSR202010071BR','4005602309'
	insert into #tmp_num_proc_num_po select  'EMCSR202010072BR','4005602317'
	insert into #tmp_num_proc_num_po select  'EMCSR202010073BR','4005602326'
	insert into #tmp_num_proc_num_po select  'EMCSR202010075BR','4005592904'
	insert into #tmp_num_proc_num_po select  'EMCSR202010076BR','4005592900'
	insert into #tmp_num_proc_num_po select  'EMCSR202010077BR','4005592901'
	insert into #tmp_num_proc_num_po select  'EMCSR202010079BR','4005551987'
	insert into #tmp_num_proc_num_po select  'EMCSR202010080BR','4005382513'
	insert into #tmp_num_proc_num_po select  'EMCSR202010082BR','0111576319'
	insert into #tmp_num_proc_num_po select  'EMCSR202010084BR','4005423825'
	insert into #tmp_num_proc_num_po select  'EMCSR202010085BR','4005423827'
	insert into #tmp_num_proc_num_po select  'EMCSR202010087BR','0150761214'
	insert into #tmp_num_proc_num_po select  'EMCSR202010091BR','4005554995'
	insert into #tmp_num_proc_num_po select  'EMCSR202010095BR','4005562422'
	insert into #tmp_num_proc_num_po select  'EMCSR202010096BR','4005532013'
	insert into #tmp_num_proc_num_po select  'EMCSR202010098BR','0111734419'
	insert into #tmp_num_proc_num_po select  'EMCSR202010102BR','0150763207'
	insert into #tmp_num_proc_num_po select  'EMCSR202010105BR','0150756714'
	insert into #tmp_num_proc_num_po select  'EMCSR202010108BR','4005579412'
	insert into #tmp_num_proc_num_po select  'EMCSR202010115BR','4005561901'
	insert into #tmp_num_proc_num_po select  'EMCSR202010116BR','4005501659'
	insert into #tmp_num_proc_num_po select  'EMCSR202011005BR','0111556126'
	insert into #tmp_num_proc_num_po select  'EMCSR202011008BR','4005554408'
	insert into #tmp_num_proc_num_po select  'EMCSR202011011BR','4005554509'
	insert into #tmp_num_proc_num_po select  'EMCSR202011013BR','4005592902'
	insert into #tmp_num_proc_num_po select  'EMCSR202011020BR','4005593056'
	insert into #tmp_num_proc_num_po select  'EMCSR202011022BR','4005596066'
	insert into #tmp_num_proc_num_po select  'EMCSR202011024BR','4005591938'
	insert into #tmp_num_proc_num_po select  'EMCSR202011031BR','0111777062'
	insert into #tmp_num_proc_num_po select  'EMCSR202011032BR','4005602796'
	insert into #tmp_num_proc_num_po select  'EMCSR202011033BR','0150761218'
	insert into #tmp_num_proc_num_po select  'EMCSR202011036BR','0150761233'
	insert into #tmp_num_proc_num_po select  'EMCSR202011039BR','4005591939'
	insert into #tmp_num_proc_num_po select  'EMCSR202011041BR','4005591941'
	insert into #tmp_num_proc_num_po select  'EMCSR202011044BR','4005554559'
	insert into #tmp_num_proc_num_po select  'EMCSR202011047BR','4005490518'
	insert into #tmp_num_proc_num_po select  'EMCSR202011049BR','4005476756'
	insert into #tmp_num_proc_num_po select  'EMCSR202011053BR','4005554581'
	insert into #tmp_num_proc_num_po select  'EMCSR202011056BR','0150763126'
	insert into #tmp_num_proc_num_po select  'EMCSR202011059BR','4005562864'
	insert into #tmp_num_proc_num_po select  'EMCSR202011061BR','4005615385'
	insert into #tmp_num_proc_num_po select  'EMCSR202011063BR','0150763125'
	insert into #tmp_num_proc_num_po select  'EMCSR202011068BR','4005615653'
	insert into #tmp_num_proc_num_po select  'EMCSR202011069BR','0111803635'
	insert into #tmp_num_proc_num_po select  'EMCSR202011072BR','4005622546'
	insert into #tmp_num_proc_num_po select  'EMCSR202011073BR','4005628156'
	insert into #tmp_num_proc_num_po select  'EMCSR202011075BR','4005628157'
	insert into #tmp_num_proc_num_po select  'EMCSR202011076BR','4005628158'
	insert into #tmp_num_proc_num_po select  'EMCSR202011082BR','4005622889'
	insert into #tmp_num_proc_num_po select  'EMCSR202011085BR','0111814287'
	insert into #tmp_num_proc_num_po select  'EMCSR202011087BR','0150763128'
	insert into #tmp_num_proc_num_po select  'EMCSR202011088BR','0150763127'
	insert into #tmp_num_proc_num_po select  'EMCSR202011090BR','4005490521'
	insert into #tmp_num_proc_num_po select  'EMCSR202011099BR','4005610086'
	insert into #tmp_num_proc_num_po select  'EMCSR202011105BR','4005634413'
	insert into #tmp_num_proc_num_po select  'EMCSR202011106BR','4005554927'
	insert into #tmp_num_proc_num_po select  'EMCSR202011107BR','4005419980'
	insert into #tmp_num_proc_num_po select  'EMCSR202011112BR','4005605750'
	insert into #tmp_num_proc_num_po select  'EMCSR202011115BR','4005581728'
	insert into #tmp_num_proc_num_po select  'EMCSR202011117BR','4005650740'
	insert into #tmp_num_proc_num_po select  'EMCSR202011119BR','4005650771'
	insert into #tmp_num_proc_num_po select  'EMCSR202011122BR','4005650776'
	insert into #tmp_num_proc_num_po select  'EMCSR202011123BR','4005650779'
	insert into #tmp_num_proc_num_po select  'EMCSR202012011BR','0111770992'
	insert into #tmp_num_proc_num_po select  'EMCSR202012015BR','4005698374'
	insert into #tmp_num_proc_num_po select  'EMCSR202012018BR','0111770974'
	insert into #tmp_num_proc_num_po select  'EMCSR202012020BR','0111771118'
	insert into #tmp_num_proc_num_po select  'EMCSR202012021BR','0111771489'
	insert into #tmp_num_proc_num_po select  'EMCSR202012024BR','4005682723'
	insert into #tmp_num_proc_num_po select  'EMCSR202012043BR','4005608239'
	insert into #tmp_num_proc_num_po select  'EMCSR202012052BR','4005699498'
	insert into #tmp_num_proc_num_po select  'EMCSR202012087BR','4005716228'
	insert into #tmp_num_proc_num_po select  'EOCSR201912011BR','4004832342'
	insert into #tmp_num_proc_num_po select  'EOCSR202001001BR','4004832332'
	insert into #tmp_num_proc_num_po select  'EOCSR202001004BR','4004864898'
	insert into #tmp_num_proc_num_po select  'EOCSR202001008BR','4004832295'
	insert into #tmp_num_proc_num_po select  'EOCSR202001013BR','4004939254'
	insert into #tmp_num_proc_num_po select  'EOCSR202001015BR','0150698489'
	insert into #tmp_num_proc_num_po select  'EOCSR202001016BR','0150700968'
	insert into #tmp_num_proc_num_po select  'EOCSR202001018BR','0150698513'
	insert into #tmp_num_proc_num_po select  'EOCSR202002005BR','0150689694'
	insert into #tmp_num_proc_num_po select  'EOCSR202002006BR','0150701385'
	insert into #tmp_num_proc_num_po select  'EOCSR202002008BR','0150698512'
	insert into #tmp_num_proc_num_po select  'EOCSR202002009BR','0150704963'
	insert into #tmp_num_proc_num_po select  'EOCSR202003003BR','0110829309'
	insert into #tmp_num_proc_num_po select  'EOCSR202003004BR','4005025701'
	insert into #tmp_num_proc_num_po select  'EOCSR202003008BR','0150713727'
	insert into #tmp_num_proc_num_po select  'EOCSR202003010BR','4005047331'
	insert into #tmp_num_proc_num_po select  'EOCSR202003012BR','4005088841'
	insert into #tmp_num_proc_num_po select  'EOCSR202003014BR','0150707578'
	insert into #tmp_num_proc_num_po select  'EOCSR202008001BR','4005387987'
	insert into #tmp_num_proc_num_po select  'EOCSR202008003BR','4005387991'
	insert into #tmp_num_proc_num_po select  'EOCSR202008008BR','4005387992'
	insert into #tmp_num_proc_num_po select  'EOCSR202008014BR','4005413341'
	insert into #tmp_num_proc_num_po select  'EOCSR202008018BR','4005413335'
	insert into #tmp_num_proc_num_po select  'EOCSR202008022BR','4005406312'
	insert into #tmp_num_proc_num_po select  'EOCSR202008023BR','4005332484'
	insert into #tmp_num_proc_num_po select  'EOCSR202008024BR','4005430561'
	insert into #tmp_num_proc_num_po select  'EOCSR202008029BR','0111488351'
	insert into #tmp_num_proc_num_po select  'EOCSR202009002BR','0150753620'
	insert into #tmp_num_proc_num_po select  'EOCSR202009004BR','0150753334 - 150753334'
	insert into #tmp_num_proc_num_po select  'EOCSR202009005BR','0150747643'
	insert into #tmp_num_proc_num_po select  'EOCSR202010002BR','4005496985'
	insert into #tmp_num_proc_num_po select  'EOCSR202010003BR','4005521838'
	insert into #tmp_num_proc_num_po select  'EOCSR202010004BR','0111532962'
	insert into #tmp_num_proc_num_po select  'EOCSR202010008BR','0150761228'
	insert into #tmp_num_proc_num_po select  'EOCSR202010011BR','0111693087'
	insert into #tmp_num_proc_num_po select  'EOCSR202010014BR','150762898'
	insert into #tmp_num_proc_num_po select  'EOCSR202011001BR','0150761229'
	insert into #tmp_num_proc_num_po select  'EOCSR202011008BR','0111798741'
	insert into #tmp_num_proc_num_po select  'EOCSR202011011BR','0150713930'
	insert into #tmp_num_proc_num_po select  'EOCSR202011013BR','0111772329'
	insert into #tmp_num_proc_num_po select  'EOCSR202012002BR','150769617'
	insert into #tmp_num_proc_num_po select  'EOCSR202012004BR','4005605798'
	insert into #tmp_num_proc_num_po select  'EOCSR202012008BR','0150743428'
	insert into #tmp_num_proc_num_po select  'EOCSR202012013BR','0150776958'
	insert into #tmp_num_proc_num_po select  'EOCSR202012014BR','0111900693'
	insert into #tmp_num_proc_num_po select  'EOCSR202012020BR','0150765822'
	insert into #tmp_num_proc_num_po select  'IOCSR202004009BR','4005136038'
	insert into #tmp_num_proc_num_po select  'IOCSR202004022BR','4005119143'
	insert into #tmp_num_proc_num_po select  'IOCSR202004023BR','4005169393'
	insert into #tmp_num_proc_num_po select  'EOCSR202003015BR','4005076713'
	insert into #tmp_num_proc_num_po select  'EOCSR202003018BR','0110851727'
	insert into #tmp_num_proc_num_po select  'EOCSR202004001BR','4005075919'
	insert into #tmp_num_proc_num_po select  'EOCSR202005003BR','0150722929'
	insert into #tmp_num_proc_num_po select  'EOCSR202005005BR','0111173992'
	insert into #tmp_num_proc_num_po select  'EOCSR202005006BR','111148134'
	insert into #tmp_num_proc_num_po select  'EOCSR202006001BR','4005278032'
	insert into #tmp_num_proc_num_po select  'EOCSR202006002BR','4005278036'
	insert into #tmp_num_proc_num_po select  'EOCSR202006004BR','4005273539'
	insert into #tmp_num_proc_num_po select  'EOCSR202006010BR','0150730993'
	insert into #tmp_num_proc_num_po select  'EOCSR202006011BR','0110874899'
	insert into #tmp_num_proc_num_po select  'EOCSR202007007BR','4005349708'
	insert into #tmp_num_proc_num_po select  'EOCSR202007008BR','4005349710'
	insert into #tmp_num_proc_num_po select  'EOCSR202007012BR','4005339514'
	insert into #tmp_num_proc_num_po select  'EOCSR202007017BR','4005343354'
	insert into #tmp_num_proc_num_po select  'EOCSR202007018BR','0150703724'
	insert into #tmp_num_proc_num_po select  'EOCSR202007022BR','0150704904'
	insert into #tmp_num_proc_num_po select  'EOCSR202007023BR','4005365309'
	insert into #tmp_num_proc_num_po select  'EOCSR202007025BR','4005365319'
	insert into #tmp_num_proc_num_po select  'EOCSR202007026BR','4005365328'
	insert into #tmp_num_proc_num_po select  'EOCSR202007032BR','4005374189'
	insert into #tmp_num_proc_num_po select  'EOCSR202007038BR','4005374274'
	insert into #tmp_num_proc_num_po select  'EOCSR202007041BR','4005374319'
	insert into #tmp_num_proc_num_po select  'EOCSR202007044BR','4005374323'
	insert into #tmp_num_proc_num_po select  'EOCSR202007047BR','4005365246'
	insert into #tmp_num_proc_num_po select  'EOCSR202007048BR','4005359885'
	insert into #tmp_num_proc_num_po select  'EOCSR202008002BR','4005387989'
	insert into #tmp_num_proc_num_po select  'EOCSR202008019BR','4005413339'
	insert into #tmp_num_proc_num_po select  'EOCSR202008020BR','0150743369'
	insert into #tmp_num_proc_num_po select  'EOCSR202008025BR','0111441141'
	insert into #tmp_num_proc_num_po select  'EOCSR202008026BR','0150743423'
	insert into #tmp_num_proc_num_po select  'EOCSR202008030BR','0150713896'
	insert into #tmp_num_proc_num_po select  'EOCSR202009003BR','0111544885 - 111544885'
	insert into #tmp_num_proc_num_po select  'EOCSR202009006BR','4005493783'
	insert into #tmp_num_proc_num_po select  'EOCSR202010005BR','0111652831'
	insert into #tmp_num_proc_num_po select  'EOCSR202010006BR','0150756285'
	insert into #tmp_num_proc_num_po select  'EOCSR202010016BR','150762965'
	insert into #tmp_num_proc_num_po select  'EOCSR202011003BR','0150767640'
	insert into #tmp_num_proc_num_po select  'EOCSR202011007BR','0111663999'
	insert into #tmp_num_proc_num_po select  'EOCSR202011014BR','4005638111'
	insert into #tmp_num_proc_num_po select  'EOCSR202012005BR','4005631284'
	insert into #tmp_num_proc_num_po select  'EOCSR202012007BR','0150762925'
	insert into #tmp_num_proc_num_po select  'EOCSR202012010BR','0150773373'
	insert into #tmp_num_proc_num_po select  'EOCSR202012011BR','150773374'
	insert into #tmp_num_proc_num_po select  'EOCSR202012012BR','4005644382' 
end         
      


select distinct 
UPPER(da.Num_Proc)		Num_Proc,                       
UPPER(nome_arquivo)		nome_arquivo,                      
UPPER(da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','')) + '.pdf' NOME_DOC, 
--replace(replace(
--	case when po.Numero_PO = ''   
--	then 'SalesOrderNotFound'  
--	else 
--		(case when po.Numero_PO = '-' 
--		then 'SalesOrderNotFound' 
--		else po.Numero_PO  end) 
--	end 
--,' ',''),'/','_')   pasta_01,
isnull(tmp.numero_po,'PONotFound' + da.Num_Proc)  pasta_01,

DMS_Code  
,da.Id_DC     
from vwClienteALLJOBS V (nolock)                   
inner join doc_anexos DA (nolock)           
	on V.Num_Proc = DA.Num_Proc   
inner Join Tipo_DoC_Cliente TC (nolock) 
	on TC.id_dc=da.Id_DC 
	and DMS_Code is not null 
inner join #tmp_num_proc_num_po tmp (nolock)      
	on da.Num_Proc          = tmp.num_proc    
--left join vwPO PO (nolock) 
--	on da.Num_Proc = PO.Num_proc 
--	and  PO.ID_DC = 3 -- 3 = sales order
--where 1 =1


--and  cd_cliente in (	select cd_pes 
--					from Pessoa_LLP         
--					where Cd_Pes_Grupo in (select Cd_Pes 
--											from Pessoa  
--											where Apelido in ( 'GRUPO OXITENO')        
--											)    
--					) -- Oxiteno
--AND LEFT(V.NUM_PROC,1) = 'E' -- Exportação
--and year(ATD) = '2020' -- ATD 2020

order by 1,4


SET NOCOUNT OFF 


--SET NOCOUNT ON          
----  SET NOCOUNT OFF   

--select distinct UPPER(da.Num_Proc) Num_Proc,                       
-- UPPER(nome_arquivo) nome_arquivo,                      
-- UPPER(da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','')) + '.pdf' NOME_DOC, 
--'Documentos' pasta,  
-- DMS_Code       
-- from doc_anexos DA with(nolock)                      
-- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null 
--where                      
--   DA.Num_Proc in   ('IASPC202009015BR'
--					,'IMSPC202010008BR'
--					,'IMSPC202010009BR'
--					,'IMSPC202008001BR'
--					,'IMSPC202008009BR'
--					,'IMSPC202008010BR'
--					,'IMSPC202008011BR'
--					,'IMSPC202008013BR'
--					,'IMSPC202008015BR'
--					,'IMSPC202008016BR'
--					,'IMSPC202008019BR'
--					,'IMSPC202008020BR'
--					,'IMSPC202008021BR'
--					,'IMSPC202008024BR'
--					,'IMSPC202008026BR'
--					,'IMSPC202009003BR'
--					,'IMSPC202009004BR'
--					,'IMSPC202009005BR'
--					,'IMSPC202009007BR'
--					,'IMSPC202009008BR'
--					,'IMSPC202009009BR'
--					,'IMSPC202009015BR'
--					,'IMSPC202009017BR'
--					,'IMSPC202009018BR'
--					,'IMSPC202009021BR'
--					,'IMSPC202009022BR'
--					,'IMSPC202009025BR'
--					,'IMSPC202009026BR'
--					,'IMSPC202009028BR'
--					,'IMSPC202009029BR'
--					,'IMSPC202009030BR'
--					,'IMSPC202009032BR'
--					,'IMSPC202009037BR'
--					,'IMSPC202009038BR'
--					,'IMSPC202009039BR')                     
--	and TC.ID_DC in (10,195,040,075,5)                   

--SET NOCOUNT OFF   

--select distinct      
          
-- SUBSTRING(upper(DA.Num_Proc),1,2) as pasta        
-- ,upper(DA.Num_Proc) as pasta2        
-- ,UPPER(nome_arquivo) nome_arquivo                        
-- ,UPPER(DA.Num_Proc+'_'+REPLACE(TC.nome_dc,' ','')) + '.pdf' as NOME_DOC        
-- ,da.Id_DC                  
-- from vwClienteALLJOBS V (nolock)                   
-- inner join doc_anexos DA with(nolock)           
--	on V.Num_Proc = DA.Num_Proc                 
-- inner Join Tipo_DoC_Cliente TC (nolock)           
--	on TC.id_dc=da.Id_DC          
-- where  cd_cliente in (	select cd_pes 
--						from Pessoa_LLP         
--						where Cd_Pes_Grupo in (select Cd_Pes 
--												from Pessoa  
--												where Apelido in ( 'GRUPO GIVAUDAN','GRUPO GIVAUDAN AROMA')        
--												)    
--						)
--and DA.id_dc = 5  


  
   



/*
--===================================================================================================================    
--============================ Anual envio de documentos - Bruno brianezze ==========================================    
--===================================================================================================================    
 /*  
select * from Tipo_Tarefas  where nome_task = 'GR Efetivo'  
select * from Tipo_Tarefas  where nome_task = 'Averbação' and cd_pes_grupo = '10017'  
*/  

create table #tmp_num_proc           
(               
num_proc varchar(16) COLLATE Latin1_General_CI_AI           
)             
         
if 1 = 1         
begin     
insert into #tmp_num_proc select  'IMOCV201908006BR'
end
  
select distinct    
        
 SUBSTRING(upper(DA.Num_Proc),1,2) as pasta      
 ,upper(DA.Num_Proc) as pasta2      
 ,UPPER(nome_arquivo) nome_arquivo              
 --,UPPER(DA.Num_Proc+'_'+ isnull(smart_doc,'')) + '.pdf' as NOME_DOC,       
 ,UPPER(DA.Num_Proc+'_'+REPLACE(TC.nome_dc,' ','')) + '.pdf' as NOME_DOC      
 ,da.Id_DC        
 --,ID_Status         
from vwClienteALLJOBS V (nolock)                 
 inner join doc_anexos DA (nolock)         
  on V.Num_Proc = DA.Num_Proc               
 inner Join Tipo_DoC_Cliente TC (nolock)         
  on TC.id_dc=da.Id_DC        
 inner join tarefas_processos tp (nolock)          
  on V.Num_Proc =  tp.Num_Proc  
 where v.num_proc in (select num_proc from #tmp_num_proc )    
 and da.ID_DC in ('10')    

  
SET NOCOUNT OFF      
*/














/*Verificação das quantidades do filtro    
    
 select       
   COUNT(DISTINCT upper(DA.Num_Proc)) as qtd_jobs    
  ,COUNT(da.Id_DC ) as qtd_doc    
     
        
  --select * from Tipo_DoC_Cliente      
        
 from vwClienteALLJOBS V (nolock)                 
 inner join doc_anexos DA with(nolock)         
  on V.Num_Proc = DA.Num_Proc               
 inner Join Tipo_DoC_Cliente TC (nolock)         
  on TC.id_dc=da.Id_DC        
 inner join tarefas_processos tp        
  on V.Num_Proc =  tp.Num_Proc     
  inner join Campo_Processo cp         
  on V.Num_Proc =  cp.Num_Proc           
 --left join vwPO PO with(nolock)       
 -- on da.Num_Proc = PO.Num_proc and  PO.ID_DC = 1        
          
 where   ID_Status in (8,5)      
 and cd_cliente in (select cd_pes from Pessoa_LLP       
      where Cd_Pes_Grupo in       
       --(select Cd_Pes from Pessoa  where Apelido = 'GRUPO DOW')      
       --(select Cd_Pes from Pessoa  where Apelido = 'GRUPO CORTEVA')      
       (select Cd_Pes from Pessoa  where Apelido = 'GRUPO DUPONT')      
      )      
          
 and tp.id_Task=4        
 and tp.dt_Conclusao between '2019-01-01 00:00:00.000' and '2019-12-31 23:59:59.999'      
        
 and cp.Id_Campo = 32     
 and cp.Campo_Dados = 1    
*/      
    
  
        
        
/*  
--===================================================================================================================    
--============================ sob demanda lista de jobs ==========================================    
--===================================================================================================================    
create table #tmp_num_proc           
(               
num_proc varchar(16) COLLATE Latin1_General_CI_AI           
)             
         
if 1 = 1         
begin    
  
insert into #tmp_num_proc select  'EMCSR201902081BR'  

  
    
end         
    
    
 select  DISTINCT      
  UPPER(nome_arquivo) nome_arquivo               
  ,UPPER(DA.Num_Proc+'_'+REPLACE(TC.nome_dc,' ','')) + '.pdf' as NOME_DOC      
  ,da.Id_DC        
  ,ID_Status      
 from vwClienteALLJOBS V (nolock)                 
 inner join doc_anexos DA with(nolock)         
  on V.Num_Proc = DA.Num_Proc               
 inner Join Tipo_DoC_Cliente TC (nolock)         
  on TC.id_dc=da.Id_DC        
 where v.num_proc in (select num_proc from #tmp_num_proc )    
 and da.ID_DC in ('204')    
 */  
    
        
        
 /*    
--===================================================================================================================    
--============================ IMPO E EXPO - ==========================================    
--===================================================================================================================    
     
 select   --top 100      
  --case when po.Numero_PO = ''   then 'PONotFound'  else (case when po.Numero_PO = '-' then 'PONotFound' else po.Numero_PO  end) end         
  --,replacE(replacE(replace(ltrim(rtrim((numero_po  ))),' ',''),'/','-'),'\','') as pasta            
  case when SUBSTRING(upper(DA.Num_Proc),1,1) = 'I' then 'Importação' else 'Exportação' end  as pasta      
  --,upper(DA.Num_Proc) as pasta2      
  ,UPPER(nome_arquivo) nome_arquivo              
  --,UPPER(DA.Num_Proc+'_'+ isnull(smart_doc,'')) + '.pdf' as NOME_DOC,       
  ,UPPER(DA.Num_Proc+'_'+REPLACE(TC.nome_dc,' ','')) + '.pdf' as NOME_DOC      
  ,da.Id_DC        
  ,ID_Status      
        
  --select * from Tipo_DoC_Cliente      
        
 from vwClienteALLJOBS V (nolock)                 
 inner join doc_anexos DA with(nolock)         
  on V.Num_Proc = DA.Num_Proc               
 inner Join Tipo_DoC_Cliente TC (nolock)         
  on TC.id_dc=da.Id_DC        
 inner join tarefas_processos tp        
  on V.Num_Proc =  tp.Num_Proc     
  inner join Campo_Processo cp         
  on V.Num_Proc =  cp.Num_Proc           
 --left join vwPO PO with(nolock)       
 -- on da.Num_Proc = PO.Num_proc and  PO.ID_DC = 1        
          
 where v.num_proc in (select num_proc from #tmp_num_proc )    
 and SUBSTRING(upper(DA.Num_Proc),1,1) = 'I'     
 and da.ID_DC in ('020','005')    
    
    
        
   union    
       
       
   select   --top 100      
  --case when po.Numero_PO = ''   then 'PONotFound'  else (case when po.Numero_PO = '-' then 'PONotFound' else po.Numero_PO  end) end         
  --,replacE(replacE(replace(ltrim(rtrim((numero_po  ))),' ',''),'/','-'),'\','') as pasta            
  case when SUBSTRING(upper(DA.Num_Proc),1,1) = 'I' then 'Importação' else 'Exportação' end  as pasta        
  --,upper(DA.Num_Proc) as pasta2      
  ,UPPER(nome_arquivo) nome_arquivo              
  --,UPPER(DA.Num_Proc+'_'+ isnull(smart_doc,'')) + '.pdf' as NOME_DOC,       
  ,UPPER(DA.Num_Proc+'_'+REPLACE(TC.nome_dc,' ','')) + '.pdf' as NOME_DOC      
  ,da.Id_DC        
  ,ID_Status      
        
  --select * from Tipo_DoC_Cliente      
        
 from vwClienteALLJOBS V (nolock)                 
 inner join doc_anexos DA with(nolock)         
  on V.Num_Proc = DA.Num_Proc               
 inner Join Tipo_DoC_Cliente TC (nolock)         
  on TC.id_dc=da.Id_DC        
 inner join tarefas_processos tp        
  on V.Num_Proc =  tp.Num_Proc     
  inner join Campo_Processo cp         
  on V.Num_Proc =  cp.Num_Proc           
 --left join vwPO PO with(nolock)       
 -- on da.Num_Proc = PO.Num_proc and  PO.ID_DC = 1        
          
 where v.num_proc in (select num_proc from #tmp_num_proc )    
 and SUBSTRING(upper(DA.Num_Proc),1,1) = 'E'     
 and da.ID_DC in ('020','010')    
    
 ORDER BY       
  case when SUBSTRING(upper(DA.Num_Proc),1,1) = 'I' then 'Importação' else 'Exportação' end    
  ,UPPER(DA.Num_Proc+'_'+REPLACE(TC.nome_dc,' ','')) + '.pdf'    
        
 */       
        
        
        
      
--===================================================================================================================    
-- ===================================================================================================================    
    
        
        
 /*    
 --===================================================================================================================    
--============================ ENVIO DOCUMENTOS SISCOSERV TIAGO =====================================================    
--===================================================================================================================     
     
                  
select          
numero_po as Numero_PO,             
replacE(replacE(replace(ltrim(rtrim((numero_po))),' ',''),'/','-'),'\','') as pasta,                 
UPPER(nome_arquivo) nome_arquivo,                  
-- UPPER('PO_' + replacE(replacE(replace((        
--numero_po         
-- ),' ',''),'/','-'),'\','') + '_' +DA.Num_Proc+'_'+ isnull(smart_doc,'') + '.pdf') as NOME_DOC,           
UPPER(DA.Num_Proc+'_'+ isnull(smart_doc,'')) + '.pdf' as NOME_DOC,                         
da.Id_DC                 
from doc_anexos DA (nolock)                
inner Join Tipo_DoC_Cliente TC (nolock)         
 on TC.id_dc=da.Id_DC            
inner join #tmp_num_proc tmp (nolock)          
 on da.Num_Proc = tmp.num_proc           
 --inner join vwClienteALLJOBS a (nolock)         
 --on A.Num_Proc = DA.Num_Proc                  
 --inner join Pessoa P         
 --on P.cd_pes = A.cd_cliente                 
 --inner join tarefas_processos tp         
 --on da.Num_Proc =  tp.Num_Proc        
where         
--tp.id_Task=4        
--and tp.dt_Conclusao between '2019-08-01 00:00:00.000' and '2019-08-31 00:00:00.000' and        
da.Id_DC in (15,20,44,74,149,177,178,180,181)         
--and da.Num_Proc in (select Num_Proc from #tmp_num_proc (nolock))            
ORDER BY dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1)       
        
        
set nocount off        
    
     
 */        
          
                  
                  
 /*                 
 create table #tmp_num_proc           
 (          
 numero_po varchar(16) COLLATE Latin1_General_CI_AI           
 ,num_proc varchar(16) COLLATE Latin1_General_CI_AI           
 )             
         
if 1 = 1         
begin        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201706002BR'        
  
        
end         
        
        
        
                  
                  
select          
numero_po as Numero_PO,           
        
        
        
replacE(replacE(replace(ltrim(rtrim((        
numero_po        
))),' ',''),'/','-'),'\','') as pasta,                 
 UPPER(nome_arquivo) nome_arquivo,                  
-- UPPER('PO_' + replacE(replacE(replace((        
--numero_po         
-- ),' ',''),'/','-'),'\','') + '_' +DA.Num_Proc+'_'+ isnull(smart_doc,'') + '.pdf') as NOME_DOC,         
        
        
        
 UPPER(DA.Num_Proc+'_'+ isnull(smart_doc,'')) + '.pdf' as NOME_DOC,         
                           
 da.Id_DC                 
 from doc_anexos DA with(nolock)                
 inner Join Tipo_DoC_Cliente TC (nolock)         
 on TC.id_dc=da.Id_DC            
inner join #tmp_num_proc tmp        
 on da.Num_Proc          = tmp.num_proc           
 --inner join vwClienteALLJOBS a (nolock)         
 --on A.Num_Proc = DA.Num_Proc                  
 --inner join Pessoa P         
 --on P.cd_pes = A.cd_cliente                 
 --inner join tarefas_processos tp         
 --on da.Num_Proc =  tp.Num_Proc        
where         
--tp.id_Task=4        
--and tp.dt_Conclusao between '2019-08-01 00:00:00.000' and '2019-08-31 00:00:00.000' and        
da.Id_DC in (15,20,44,74,149,177,178,180,181)         
--and da.Num_Proc in (select Num_Proc from #tmp_num_proc (nolock))        
        
        
  select * from tipo_tarefas  where id_task = 4       
        
        
ORDER BY dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1)        
  */     
        
        
/*        
select * from Tipo_DoC_Cliente        
        
002 - Invoice        
011 - Packing list        
020 - Doc. Embarque        
021 - Certificado de Seguro        
023 - Li number        
044 - BL original        
005 - DI number        
006 - CI number        
010 - Nota Fiscal        
013 - Certificado de Origem        
060 - Prestação de Contas        
075 - Guia de exoneração ICMS        
0143 - SDA        
*/        
        
        
/*     
        
        
        
    alter procedure [dbo].[spPDFKHDA_NEW2]               
              
AS              
              
              
              
select distinct dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1),               
 UPPER(nome_arquivo) nome_arquivo,              
 UPPER('PO_' + replacE(replacE(replace(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1),' ',''),'/','-'),'\','') + '_' +DA.Num_Proc+'_'+ smart_doc + '.pdf') as NOME_DOC,               
 --isnull(replace(replace(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,3),' ',''),'/',''),'SalesOrder_NotFound') pasta,              
 --isnull(replace(replace(po.Numero_PO,' ',''),'/',''),'PONotFound') pasta,              
 --replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1),'PONotFound'),' ',''),'/','')  pasta,              
 DMS_Code             
 from doc_anexos DA with(nolock)            
 inner Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC                    
 --join Fatura_CHB F on left(F.Fatura_PC,16) = DA.Num_Proc        
 join vwClienteALLJOBS a with(nolock) on A.Num_Proc = DA.Num_Proc              
 join Pessoa P on P.cd_pes = A.cd_cliente              
 inner join tarefas_processos tp on da.Num_Proc =  tp.Num_Proc    
where tp.id_Task=4    
and  tp.dt_Conclusao between '2019-08-01 00:00:00.000' and '2019-08-31 00:00:00.000'    
and p.Apelido in     
(    
'GRUPO DUPONT'    
,'DOW AGROSCI - 1616C'    
,'DOW AGROSCI - 1617C'    
,'DOW - 3770C'    
)    
and da.Id_DC in (11,16,2,23,25,20,6,5,44,10)    
ORDER BY dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1)    
  
PL 011 COA 016 Invoice 002 LI 023 REQ MAPA 025 DOC de embarque 020 CI 006 DI 005 BL 044 NF 010    
*/    
    
    
/*  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
alter procedure [dbo].[spPDFKHDA_NEW2]               
              
AS              
SET NOCOUNT ON                  
 create table #tmp_num_proc       
 (      
 num_proc varchar(16) COLLATE Latin1_General_CI_AI       
 )         
      
              
select      
(select top 1 Numero_PO from vwPO_ALL (nolock) where num_proc = DA.Num_Proc order by ID_PO) as Numero_PO,       
replacE(replacE(replace(ltrim(rtrim((select top 1 Numero_PO from vwPO_ALL (nolock) where num_proc = DA.Num_Proc order by ID_PO))),' ',''),'/','-'),'\','') as pasta,             
 UPPER(nome_arquivo) nome_arquivo,              
 UPPER('PO_' + replacE(replacE(replace((select top 1 Numero_PO from vwPO_ALL (nolock) where num_proc = DA.Num_Proc order by ID_PO),' ',''),'/','-'),'\','') + '_' +DA.Num_Proc+'_'+ smart_doc + '.pdf') as NOME_DOC,                        
 DMS_Code             
 from doc_anexos DA with(nolock)            
 inner Join Tipo_DoC_Cliente TC (nolock)     
 on TC.id_dc=da.Id_DC                    
 --inner join vwClienteALLJOBS a (nolock)     
 --on A.Num_Proc = DA.Num_Proc              
 --inner join Pessoa P     
 --on P.cd_pes = A.cd_cliente              
 --inner join tarefas_processos tp     
 --on da.Num_Proc =  tp.Num_Proc    
where     
--tp.id_Task=4    
--and tp.dt_Conclusao between '2019-08-01 00:00:00.000' and '2019-08-31 00:00:00.000' and    
 da.Id_DC in (2,11,20,21,23,44,5,6,10,13,60,75,143)    
and da.Num_Proc in (select Num_Proc from #tmp_num_proc (nolock))    
    
ORDER BY dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1)    
    
    
    
/*    
select * from Tipo_DoC_Cliente    
    
002 - Invoice    
011 - Packing list    
020 - Doc. Embarque    
021 - Certificado de Seguro    
023 - Li number    
044 - BL original    
005 - DI number    
006 - CI number    
010 - Nota Fiscal    
013 - Certificado de Origem    
060 - Prestação de Contas    
075 - Guia de exoneração ICMS    
0143 - SDA    
*/  
     
        
        
*/
GO
