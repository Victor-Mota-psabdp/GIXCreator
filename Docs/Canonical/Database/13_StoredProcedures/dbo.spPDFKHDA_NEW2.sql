SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Colunas obrigatorias:
--Num_Proc
--nome_arquivo
--pasta
--NOME_DOC
CREATE procedure [dbo].[spPDFKHDA_NEW2] 
AS
--cadu 100-269240
--cadu 100-276037 
--cadu 100-291512 - 13082021 16:30
--100-305666
--100-315988 
SET NOCOUNT ON          
--  SET NOCOUNT OFF 

SELECT DISTINCT 
	UPPER(da.Num_Proc) Num_Proc,    
	da.Id_DC  ,                
	UPPER(nome_arquivo) nome_arquivo,    
	UPPER(replace(nome_arquivo, '.PDF', '')+ '_' + replace(replace(vp.numero_po ,'-',''),'/','') )+ '.pdf' nome_doc,
	'Documentos' pasta
	--UPPER(da.Num_Proc + '_' + replace(replace(da.Id_DC ,' ',''),'/','')) + '.pdf' NOME_DOC                                                                              
FROM doc_anexos DA (NOLOCK)         
INNER Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null
join vwpo vp with(nolock) on vp.Num_Proc = da.Num_Proc and vp.id_dc = 1
WHERE da.Id_DC  in (005,010,040,195)   

and da.Num_Proc in (
                     
'IMLYB202111011BR',
'IMLYB202112005BR',
'IMLYB202112006BR',
'IMLYB202112007BR',
'IMLYB202112008BR',
'IMLYB202112009BR',
'IMLYB202112001BR',
'IMLYB202201007BR',
'IMLYB202201008BR',
'IMLYB202201009BR',
'IMLYB202112002BR',
'IMLYB202201006BR',
'IMLYB202201003BR',
'IMLYB202110013BR',
'IMLYB202112003BR',
'IMLYB202201005BR',
'IMLYB202201001BR',
'IMLYB202201002BR',
'IMLYB202201004BR',
'IMLYB202202005BR',
'IMLYB202202007BR',
'IMLYB202202003BR',
'IMLYB202202006BR',
'IMLYB202202008BR',
'IMLYB202202009BR',
'IMLYB202112010BR',
'IMLYB202202002BR',
'IMLYB202202001BR',
'IMLYB202201011BR',
'IMLYB202112004BR',
'IMLYB202203002BR',
'IMLYB202203004BR',
'IMLYB202203001BR',
'IMLYB202203003BR',
'IMLYB202202004BR',
'IMLYB202202012BR',
'IMLYB202112011BR',
'IMLYB202203005BR',
'IMLYB202204002BR',
'IMLYB202204003BR',
'IMLYB202204004BR',
'IMLYB202204006BR',
'IMLYB202204005BR',
'IMLYB202204007BR',
'IMLYB202204008BR',
'IMLYB202203013BR',
'IMLYB202203006BR',
'IMLYB202203010BR',
'IMLYB202204010BR',
'IMLYB202204014BR',
'IMLYB202204011BR',
'IMLYB202204013BR',
'IMLYB202204015BR',
'IMLYB202204012BR',
'IMLYB202203007BR',
'IMLYB202204009BR',
'IMLYB202203011BR',
'IMLYB202205002BR',
'IMLYB202203009BR',
'IMLYB202206005BR',
'IMLYB202206003BR',
'IMLYB202206004BR',
'IMLYB202205005BR',
'IMLYB202206001BR',
'IMLYB202206007BR',
'IMLYB202206002BR',
'IMLYB202206006BR',
'IMLYB202206008BR',
'IMLYB202206012BR',
'IMLYB202206011BR',
'IMLYB202206013BR',
'IMLYB202207008BR',
'IMLYB202208001BR',
'IMLYB202203008BR',
'IMLYB202205003BR',
'IMLYB202207003BR',
'IMLYB202208002BR',
'IMLYB202208005BR',
'IMLYB202207004BR',
'IMLYB202207007BR',
'IMLYB202208003BR',
'IMLYB202207005BR',
'IMLYB202205007BR',
'IMLYB202207001BR',
'IMLYB202206010BR',
'IMLYB202208010BR',
'IMLYB202208006BR',
'IMLYB202105020BR',
'IMLYB202205004BR',
'IMLYB202208009BR',
'IMLYB202208008BR',
'IMLYB202208011BR',
'IMLYB202208012BR',
'IMLYB202208007BR',
'IMLYB202208013BR',
'IMLYB202208014BR',
'IMLYB202209012BR',
'IMLYB202205006BR',
'IMLYB202209002BR',
'IMLYB202209004BR',
'IMLYB202209006BR',
'IMLYB202209013BR',
'IMLYB202209008BR',
'IMLYB202209011BR',
'IMLYB202209001BR',
'IMLYB202209003BR',
'IMLYB202209007BR',
'IMLYB202209010BR',
'IMLYB202209005BR',
'IMLYB202208004BR',
'IMLYB202208016BR',
'IMLYB202208015BR',
'IMLYB202208017BR',
'IMLYB202209014BR',
'IMLYB202209015BR',
'IMLYB202208018BR',
'IMLYB202209016BR',
'IMLYB202209019BR',
'IMLYB202209020BR',
'IMLYB202209021BR',
'IMLYB202209022BR',
'IMLYB202209023BR',
'IMLYB202209024BR',
'IMLYB202210004BR',
'IMLYB202210006BR',
'IMLYB202210003BR',
'IMLYB202210005BR',
'IMLYB202210007BR',
'IMLYB202210011BR',
'IMLYB202210012BR',
'IMLYB202210008BR',
'IMLYB202210010BR',
'IMLYB202210009BR',
'IMLYB202211003BR',
'IMLYB202211005BR',
'IMLYB202212001BR',
'IMLYB202211001BR',
'IMLYB202211004BR',
'IMLYB202211006BR',
'IMLYB202211008BR',
'IMLYB202211009BR',
'IMLYB202211007BR',
'IMLYB202210002BR',
'IMLYB202212004BR',
'IMLYB202212003BR',
'IMLYB202212002BR',
'IMLYB202212005BR',
'IMLYB202212006BR',
'IMLYB202301005BR',
'IMLYB202301004BR',
'IMLYB202212007BR',
'IMLYB202301002BR',
'IMLYB202301006BR',
'IMLYB202301008BR',
'IMLYB202301003BR',
'IMLYB202301007BR',
'IMLYB202302003BR',
'IMLYB202302004BR',
'IMLYB202302002BR',
'IMLYB202301009BR',
'IMLYB202302001BR',
'IMLYB202302008BR',
'IMLYB202302005BR',
'IMLYB202302006BR',
'IMLYB202302007BR',
'IMLYB202302011BR',
'IMLYB202302010BR',
'IMLYB202302009BR',
'IMLYB202302014BR',
'IMLYB202302016BR',
'IMLYB202302015BR',
'IMLYB202302013BR',
'IMLYB202302012BR',
'IMLYB202303005BR',
'IMLYB202303009BR',
'IMLYB202303012BR',
'IMLYB202303006BR',
'IMLYB202303011BR',
'IMLYB202303010BR',
'IMLYB202303007BR',
'IMLYB202303008BR',
'IMLYB202303003BR',
'IMLYB202303002BR',
'IMLYB202303004BR',
'IMLYB202304010BR',
'IMLYB202304011BR',
'IMLYB202304005BR',
'IMLYB202304006BR',
'IMLYB202304008BR',
'IMLYB202304007BR',
'IMLYB202304009BR',
'IMLYB202304001BR',
'IMLYB202304003BR',
'IMLYB202304004BR',
'IMLYB202306001BR',
'IMLYB202306002BR',
'IMLYB202307001BR',
'IMLYB202306003BR',
'IMLYB202306004BR',
'IMLYB202306005BR',
'IMLYB202307008BR',
'IMLYB202307006BR',
'IMLYB202307007BR',
'IMLYB202307004BR',
'IMLYB202307005BR',
'IMLYB202307002BR',
'IMLYB202307003BR',
'IMLYB202308001BR',
'IMLYB202308002BR',
'IMLYB202308004BR',
'IMLYB202308006BR',
'IMLYB202308003BR',
'IMLYB202308008BR',
'IMLYB202308007BR',
'IMLYB202308005BR',
'IMLYB202309002BR',
'IMLYB202309003BR',
'IMLYB202309004BR',
'IMLYB202309005BR',
'IMLYB202308012BR',
'IMLYB202308009BR',
'IMLYB202308010BR',
'IMLYB202308011BR',
'IMLYB202310004BR',
'IMLYB202311001BR',
'IMLYB202310005BR',
'IMLYB202310006BR',
'IMLYB202311002BR',
'IMLYB202309006BR',
'IMLYB202311003BR',
'IMLYB202311004BR',
'IMLYB202311007BR',
'IMLYB202311006BR',
'IMLYB202311013BR',
'IMLYB202311008BR',
'IMLYB202311005BR',
'IMLYB202311011BR',
'IMLYB202311012BR',
'IMLYB202311009BR',
'IMLYB202312003BR',
'IMLYB202312008BR',
'IMLYB202312009BR',
'IMLYB202312010BR',
'IMLYB202312006BR',
'IMLYB202312004BR',
'IMLYB202312007BR',
'IMLYB202311010BR',
'IMLYB202312016BR',
'IMLYB202312011BR',
'IMLYB202312014BR',
'IMLYB202312015BR',
'IMLYB202312012BR',
'IMLYB202312013BR',
'IMLYB202312017BR',
'IMLYB202402008BR',
'IMLYB202402009BR',
'IMLYB202402010BR',
'IMLYB202402018BR',
'IMLYB202402003BR',
'IMLYB202402020BR',
'IMLYB202402004BR',
'IMLYB202402005BR',
'IMLYB202312018BR',
'IMLYB202402007BR',
'IMLYB202402019BR',
'IMLYB202402002BR',
'IMLYB202402021BR',
'IMLYB202402022BR',
'IMLYB202402023BR',
'IMLYB202401001BR',
'IMLYB202402024BR',
'IMLYB202402006BR',
'IMLYB202402011BR',
'IMLYB202402015BR',
'IMLYB202402012BR',
'IMLYB202402013BR',
'IMLYB202402014BR',
'IMLYB202403001BR',
'IMLYB202402016BR',
'IMLYB202402017BR',
'IMLYB202403009BR',
'IMLYB202403010BR',
'IMLYB202403011BR',
'IMLYB202403007BR',
'IMLYB202403005BR',
'IMLYB202403006BR',
'IMLYB202403004BR',
'IMLYB202403008BR',
'IMLYB202404011BR',
'IMLYB202403003BR',
'IMLYB202404014BR',
'IMLYB202404017BR',
'IMLYB202404013BR',
'IMLYB202404015BR',
'IMLYB202404018BR',
'IMLYB202404016BR',
'IMLYB202404003BR',
'IMLYB202404008BR',
'IMLYB202404009BR',
'IMLYB202404004BR',
'IMLYB202404002BR',
'IMLYB202404012BR',
'IMLYB202404010BR',
'IMLYB202404005BR',
'IMLYB202405006BR',
'IMLYB202405007BR',
'IMLYB202405008BR',
'IMLYB202405001BR',
'IMLYB202405002BR',
'IMLYB202405003BR',
'IMLYB202405009BR',
'IMLYB202405013BR',
'IMLYB202405011BR',
'IMLYB202405027BR',
'IMLYB202405018BR',
'IMLYB202405026BR',
'IMLYB202405014BR',
'IMLYB202405004BR',
'IMLYB202405005BR',
'IMLYB202405024BR',
'IMLYB202405016BR',
'IMLYB202405025BR',
'IMLYB202405023BR',
'IMLYB202405020BR',
'IMLYB202405019BR',
'IMLYB202404019BR',
'IMLYB202405021BR',
'IMLYB202405022BR',
'IMLYB202407006BR',
'IMLYB202407001BR',
'IMLYB202407002BR',
'IMLYB202407004BR',
'IMLYB202405010BR',
'IMLYB202405015BR',
'IMLYB202405012BR',
'IMLYB202406004BR',
'IMLYB202406005BR',
'IMLYB202406006BR',
'IMLYB202406007BR',
'IMLYB202404006BR',
'IMLYB202404007BR',
'IMLYB202406001BR',
'IMLYB202407005BR',
'IMLYB202407019BR',
'IMLYB202407016BR',
'IMLYB202407017BR',
'IMLYB202407018BR',
'IMLYB202407014BR',
'IMLYB202407015BR',
'IMLYB202407021BR',
'IMLYB202407008BR',
'IMLYB202407011BR',
'IMLYB202407009BR',
'IMLYB202407007BR',
'IMLYB202407010BR',
'IMLYB202407012BR',
'IMLYB202407020BR',
'IMLYB202407022BR',
'IMLYB202407003BR',
'IMLYB202407024BR',
'IMLYB202407023BR',
'IMLYB202409001BR',
'IMLYB202408001BR',
'IMLYB202408002BR',
'IMLYB202408009BR',
'IMLYB202409003BR',
'IMLYB202409005BR',
'IMLYB202409008BR',
'IMLYB202406003BR',
'IMLYB202410017BR',
'IMLYB202409006BR',
'IMLYB202408003BR',
'IMLYB202408004BR',
'IMLYB202408007BR',
'IMLYB202408005BR',
'IMLYB202410004BR',
'IMLYB202408008BR',
'IMLYB202410003BR',
'IMLYB202409004BR',
'IMLYB202409009BR',
'IMLYB202409010BR',
'IMLYB202410006BR',
'IMLYB202410009BR',
'IMLYB202410007BR',
'IMLYB202409002BR',
'IMLYB202410018BR',
'IMLYB202410011BR',
'IMLYB202410001BR'

)                      
     
                     
order by  da.Id_DC

--SELECT DISTINCT 
--	UPPER(da.Num_Proc) Num_Proc,    
--	da.Id_DC,                
--	UPPER(nome_arquivo) nome_arquivo,    
--	--UPPER(replace(nome_arquivo, '.PDF', '')+ '_' + replace(replace(vp.numero_po ,'-',''),'/','') )+ '.pdf' nome_doc,
--	'Documentos' pasta,
--	UPPER(vp.Numero_PO + '_' + replace(replace(da.Id_DC ,' ',''),'/','')) + '.pdf' NOME_DOC                                                                              
--FROM doc_anexos DA (NOLOCK)         
--INNER Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC -- and DMS_Code is not null
--join vwpo vp with(nolock) on vp.Num_Proc = da.Num_Proc --and vp.id_dc in (3)
--WHERE da.Id_DC  = 222  

--and vp.Numero_PO in (
--'4200069039',
--'4200069848',
--'4200072039',
--'9000002988',
--'9000003561',
--'9000003608',
--'9000003835',
--'9000004085',
--'9000004235',
--'9000004488',
--'9000004470',
--'9000004913',
--'9000005125',
--'9000005347',
--'9000006070',
--'9000006068',
--'9000006236',
--'9000006419',
--'9000006566',
--'4320467053',
--'4320467317',
--'9000006955',
--'9000007228',
--'5500011519',
--'5500011520',
--'5500012451',
--'5500013168',
--'5500014388',
--'5500015143',
--'4000189798',
--'5500017748',
--'5500018049',
--'5500018148',
--'5500018933',
--'5500019419',
--'5500019934',
--'5500021060',
--'5500021800',
--'5500022542',
--'5500024009',
--'5500024033'
--) order by da.id_dc

--SELECT DISTINCT 
--	UPPER(da.Num_Proc) Num_Proc,    
--	da.Id_DC  ,                
--	UPPER(nome_arquivo) nome_arquivo,    
--	--UPPER(replace(nome_arquivo, '.PDF', '')+ '_' + replace(replace(vp.numero_po ,'-',''),'/','') )+ '.pdf' nome_doc,
--	'Documentos' pasta,
--	UPPER(da.Num_Proc + '_' + replace(replace(da.Id_DC ,' ',''),'/','')) + '.xml' NOME_DOC                                                                              
--FROM doc_anexos DA (NOLOCK)         
--INNER Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC -- and DMS_Code is not null
--join vwpo vp with(nolock) on vp.Num_Proc = da.Num_Proc and vp.id_dc = 5
--WHERE da.Id_DC  in (263)   

--and da.Num_Proc in (

--'IMCTV202104124BR',
--'IMCTV202104201BR',
--'IMCTV202102007BR',
--'IMCTV202011077BR',
--'IMCTV202011075BR',
--'IMCTV202101070BR',
--'IMCTV202101079BR',
--'IMCTV202101075BR',
--'IMCTV202101085BR',
--'IMCTV202101084BR',
--'IMCTV202101064BR',
--'IMCTV202101081BR',
--'IACTV202103002BR',
--'IMCTV202012057BR',
--'IMCTV202101132BR',
--'IMCTV202101131BR',
--'IMCTV202101130BR',
--'IMCTV202101129BR',
--'IMCTV202101069BR',
--'IMCTV202101073BR',
--'IMCTV202101071BR',
--'IMCTV202101068BR',
--'IMCTV202011076BR',
--'IMCTV202011078BR',
--'IMCTV202101126BR',
--'IMCTV202012066BR',
--'IMCTV202011097BR',
--'IMCTV202011093BR'

--) order by da.id_dc



--SELECT DISTINCT 
--	UPPER(DA.Num_Proc) Num_Proc,    
--	da.Id_DC  ,                
--	UPPER((DA.Num_Proc + '_' + replace(replace(da.Id_DC ,' ',''),'/','')) + '.pdf') nome_arquivo,    
--	UPPER((PA.Num_Proc + '_' + replace(replace(da.Id_DC ,' ',''),'/','')) + '.pdf') nome_doc,
--	'Documentos' pasta,
--	UPPER(PA.Numero_PO + '_' + replace(replace(da.Id_DC ,' ',''),'/','')) + '.pdf' NOME_DOC                                                                              
--FROM doc_anexos DA (NOLOCK)         
--INNER Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null
--join vwPO_ALL PA with(nolock) on PA.Num_Proc = DA.Num_Proc and da.Id_DC =pa.ID_DC and pa.ID_DC = 1
----WHERE da.Id_DC  in ( 005 )                                    

--and da.Num_Proc in                      
--(                      
--'IMOXT202011010BR')
--'IMOXT202011065BR',
--'IMOXT202011060BR',
--'IMOXT202011070BR',
--'IMOXT202011055BR',
--'IMOXT202011035BR',
--'IMOXT202012054BR',
--'IMOXT202012055BR',
--'IMOXT202012074BR',
--'IMOXT202012075BR',
--'IMOXT202012070BR',
--'IMOXT202012088BR',
--'IMOXT202012079BR',
--'IMOXT202012080BR',
--'IMOXT202012082BR',
--'IMOXT202012083BR',
--'IMOXT202012084BR',
--'IMOXT202012086BR',
--'IMOXT202101008BR',
--'IMOXT202101003BR',
--'IMOXT202101014BR',
--'IMOXT202101015BR',
--'IMOXT202101016BR',
--'IAOXT202103005BR',
--'IMOXT202102015BR',
--'IAOXT202102004BR',
--'IMOXT202101049BR',
--'IMOXT202102043BR',
--'IMOXT202102044BR',
--'IMOXT202102045BR',
--'IMOXT202101035BR',
--'IMOXT202101057BR',
--'IMOXT202101048BR',
--'IMOXT202103009BR',
--'IMOXT202103009BR',
--'IMOXT202103007BR',
--'IMOXT202101061BR',
--'IOOXT202103003BR',
--'IOOXT202103004BR',
--'IOOXT202103005BR',
--'IMOXT202103040BR',
--'IOOXT202103006BR',
--'IMOXT202103029BR',
--'IMOXT202105007BR',
--'IMOXT202105065BR',
--'IMOXT202105015BR',
--'IMOXT202105016BR',
--'IMOXT202106001BR',
--'IMOXT202104056BR',
--'IMOXT202104059BR',
--'IAOXT202105004BR',
--'IMOXT202106054BR',
--'IMOXT202106075BR',
--'IMOXT202103029BR',
--'IMOXT202106090BR',
--'IMOXT202106091BR',
--'IMOXT202107002BR',
--'IMOXT202106038BR',
--'IMOXT202201005BR',
--'IMOXT202107071BR',
--'IMOXT202107058BR',
--'IMOXT202107054BR',
--'IMOXT202107064BR',
--'IMOXT202107070BR',
--'IMOXT202107069BR',
--'IAOXT202107002BR',
--'IOOXT202107011BR',
--'IOOXT202107012BR',
--'IMOXT202107085BR',
--'IMOXT202108003BR',
--'IAOXT202108004BR',
--'IMOXT202108070BR',
--'IMOXT202108076BR',
--'IMOXT202108100BR',
--'IMOXT202109021BR',
--'IMOXT202109023BR',
--'IMOXT202109026BR',
--'IMOXT202109028BR',
--'IMOXT202107083BR',
--'IMOXT202109041BR',
--'IMOXT202109045BR',
--'IAOXT202109013BR',
--'IOOXT202110001BR',
--'IMOXT202110015BR',
--'IOOXT202110005BR',
--'IOOXT202110007BR',
--'IOOXT202110006BR',
--'IMOXT202107086BR',
--'IMOXT202110033BR',
--'IMOXT202110027BR',
--'IMOXT202110028BR',
--'IMOXT202107084BR',
--'IMOXT202110049BR',
--'IMOXT202111014BR',
--'IMOXT202109038BR',
--'IAOXT202111001BR',
--'IAOXT202111002BR',
--'IMOXT202111025BR',
--'IMOXT202112005BR',
--'IMOXT202112021BR'
--)                      
--order by  da.Id_DC             


-- tirar o comentario dps
--SELECT DISTINCT 
--	UPPER(da.Num_Proc) Num_Proc,    
--	da.Id_DC  ,                
--	UPPER(nome_arquivo) nome_arquivo,    
--	UPPER(nome_arquivo) nome_doc,
--	'Documentos' pasta
--	UPPER(da.Num_Proc + '_' + replace(replace(da.Id_DC ,' ',''),'/','')) + '.pdf' NOME_DOC                                                                              
--FROM doc_anexos DA (NOLOCK)         
--INNER Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null
--WHERE da.Id_DC  in ( 005 )                                    

--and da.Num_Proc in                      
--(                      
--'IMOXT202011010BR',
--'IMOXT202011065BR',
--'IMOXT202011060BR',
--'IMOXT202011070BR',
--'IMOXT202011055BR',
--'IMOXT202011035BR',
--'IMOXT202012054BR',
--'IMOXT202012055BR',
--'IMOXT202012074BR',
--'IMOXT202012075BR',
--'IMOXT202012070BR',
--'IMOXT202012088BR',
--'IMOXT202012079BR',
--'IMOXT202012080BR',
--'IMOXT202012082BR',
--'IMOXT202012083BR',
--'IMOXT202012084BR',
--'IMOXT202012086BR',
--'IMOXT202101008BR',
--'IMOXT202101003BR',
--'IMOXT202101014BR',
--'IMOXT202101015BR',
--'IMOXT202101016BR',
--'IAOXT202103005BR',
--'IMOXT202102015BR',
--'IAOXT202102004BR',
--'IMOXT202101049BR',
--'IMOXT202102043BR',
--'IMOXT202102044BR',
--'IMOXT202102045BR',
--'IMOXT202101035BR',
--'IMOXT202101057BR',
--'IMOXT202101048BR',
--'IMOXT202103009BR',
--'IMOXT202103009BR',
--'IMOXT202103007BR',
--'IMOXT202101061BR',
--'IOOXT202103003BR',
--'IOOXT202103004BR',
--'IOOXT202103005BR',
--'IMOXT202103040BR',
--'IOOXT202103006BR',
--'IMOXT202103029BR',
--'IMOXT202105007BR',
--'IMOXT202105065BR',
--'IMOXT202105015BR',
--'IMOXT202105016BR',
--'IMOXT202106001BR',
--'IMOXT202104056BR',
--'IMOXT202104059BR',
--'IAOXT202105004BR',
--'IMOXT202106054BR',
--'IMOXT202106075BR',
--'IMOXT202103029BR',
--'IMOXT202106090BR',
--'IMOXT202106091BR',
--'IMOXT202107002BR',
--'IMOXT202106038BR',
--'IMOXT202201005BR',
--'IMOXT202107071BR',
--'IMOXT202107058BR',
--'IMOXT202107054BR',
--'IMOXT202107064BR',
--'IMOXT202107070BR',
--'IMOXT202107069BR',
--'IAOXT202107002BR',
--'IOOXT202107011BR',
--'IOOXT202107012BR',
--'IMOXT202107085BR',
--'IMOXT202108003BR',
--'IAOXT202108004BR',
--'IMOXT202108070BR',
--'IMOXT202108076BR',
--'IMOXT202108100BR',
--'IMOXT202109021BR',
--'IMOXT202109023BR',
--'IMOXT202109026BR',
--'IMOXT202109028BR',
--'IMOXT202107083BR',
--'IMOXT202109041BR',
--'IMOXT202109045BR',
--'IAOXT202109013BR',
--'IOOXT202110001BR',
--'IMOXT202110015BR',
--'IOOXT202110005BR',
--'IOOXT202110007BR',
--'IOOXT202110006BR',
--'IMOXT202107086BR',
--'IMOXT202110033BR',
--'IMOXT202110027BR',
--'IMOXT202110028BR',
--'IMOXT202107084BR',
--'IMOXT202110049BR',
--'IMOXT202111014BR',
--'IMOXT202109038BR',
--'IAOXT202111001BR',
--'IAOXT202111002BR',
--'IMOXT202111025BR',
--'IMOXT202112005BR',
--'IMOXT202112021BR'
--)                      
--order by  da.Id_DC                   

--SELECT 	
--	UPPER(da.Num_Proc) Num_Proc,    
--	da.Id_DC  ,                
--	UPPER(nome_arquivo) nome_arquivo,  
--	'Documentos' pasta, 
--	UPPER(da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ','_'),'/','')) + '.pdf' NOME_DOC
--FROM doc_anexos DA (NOLOCK)
--INNER Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null
--WHERE da.Id_DC  in (5)                                                    
--and da.Num_Proc in ( 
--'IMCSR201707298BR',
--'IMCSR201707527BR',
--'IMCSR201708501BR',
--'IMCSR201708504BR',
--'IMCSR201708505BR',
--'IMCSR201708510BR',
--'IMCSR201708519BR',
--'IMCSR201708542BR',
--'IMCSR201709072BR',
--'IMCSR201710662BR',
--'IMCSR201711443BR',
--'IMCSR201711457BR',
--'IMCSR201711458BR',
--'IMCSR201711476BR',
--'IMCSR201711486BR',
--'IMCSR201711492BR',
--'IMCSR201711496BR',
--'IMCSR201711565BR',
--'IMCSR201712014BR',
--'IMCSR201712036BR',
--'IMCSR201712042BR',
--'IMCSR201712177BR',
--'IMCSR201712184BR',
--'IMCSR201712191BR',
--'IMCSR201712217BR',
--'IMCSR201712469BR',
--'IMCSR201712564BR',
--'IMCSR201801219BR',
--'IMCSR201801328BR',
--'IMCSR201801331BR',
--'IMCSR201801337BR',
--'IMCSR201801495BR',
--'IMCSR201801719BR',
--'IMCSR201801733BR',
--'IMCSR201802005BR',
--'IMCSR201802186BR',
--'IMCSR201802200BR',
--'IMCSR201802266BR',
--'IMCSR201802739BR',
--'IMCSR201802782BR',
--'IMCSR201803038BR',
--'IMCSR201803047BR',
--'IMCSR201803064BR',
--'IMCSR201803083BR',
--'IMCSR201803370BR',
--'IMCSR201803458BR',
--'IMCSR201803470BR',
--'IMCSR201804138BR',
--'IMCSR201804285BR',
--'IMCSR201804311BR',
--'IMCSR201804384BR',
--'IMCSR201804388BR',
--'IMCSR201804480BR',
--'IMCSR201804545BR',
--'IMCSR201804547BR',
--'IMCSR201804548BR',
--'IMCSR201804549BR',
--'IMCSR201804551BR',
--'IMCSR201804618BR',
--'IMCSR201804620BR',
--'IMCSR201804621BR',
--'IMCSR201804877BR',
--'IMCSR201804919BR',
--'IMCSR201804924BR',
--'IMCSR201804949BR',
--'IMCSR201805013BR',
--'IMCSR201805088BR',
--'IMCSR201805089BR',
--'IMCSR201805210BR',
--'IMCSR201805634BR',
--'IMCSR201805635BR',
--'IMCSR201805649BR',
--'IMCSR201805687BR',
--'IMCSR201805688BR',
--'IMCSR201805690BR',
--'IMCSR201806040BR',
--'IMCSR201806179BR',
--'IMCSR201806188BR',
--'IMCSR201806202BR',
--'IMCSR201806205BR',
--'IMCSR201806222BR',
--'IMCSR201806231BR',
--'IMCSR201806278BR',
--'IMCSR201806521BR',
--'IMCSR201806522BR',
--'IMCSR201806690BR',
--'IMCSR201806701BR',
--'IMCSR201807030BR',
--'IMCSR201807137BR',
--'IMCSR201807656BR',
--'IMCSR201807657BR',
--'IMCSR201807663BR',
--'IMCSR201808003BR',
--'IMCSR201808004BR',
--'IMCSR201808005BR',
--'IMCSR201808145BR',
--'IMCSR201808151BR',
--'IMCSR201808258BR',
--'IMCSR201808460BR',
--'IMCSR201808526BR',
--'IMCSR201808734BR',
--'IMCSR201808897BR',
--'IMCSR201809014BR',
--'IMCSR201809015BR',
--'IMCSR201809017BR',
--'IMCSR201809024BR',
--'IMCSR201809069BR',
--'IMCSR201809083BR',
--'IMCSR201809103BR',
--'IMCSR201809126BR',
--'IMCSR201809134BR',
--'IMCSR201809177BR',
--'IMCSR201809181BR',
--'IMCSR201809183BR',
--'IMCSR201809282BR',
--'IMCSR201809294BR',
--'IMCSR201809308BR',
--'IMCSR201809341BR',
--'IMCSR201809392BR',
--'IMCSR201809450BR',
--'IMCSR201809480BR',
--'IMCSR201809497BR',
--'IMCSR201809560BR',
--'IMCSR201810017BR',
--'IMCSR201810060BR',
--'IMCSR201810070BR',
--'IMCSR201810080BR',
--'IMCSR201810290BR',
--'IMCSR201810559BR',
--'IMCSR201810560BR',
--'IMCSR201810565BR',
--'IMCSR201810566BR',
--'IMCSR201810587BR',
--'IMCSR201810592BR',
--'IMCSR201810771BR',
--'IMCSR201810773BR',
--'IMCSR201810795BR',
--'IMCSR201810821BR',
--'IMCSR201810832BR',
--'IMCSR201810856BR',
--'IMCSR201810877BR',
--'IMCSR201810958BR',
--'IMCSR201811172BR',
--'IMCSR201811177BR',
--'IMCSR201811363BR',
--'IMCSR201811374BR',
--'IMCSR201811416BR',
--'IMCSR201811571BR',
--'IMCSR201812121BR',
--'IMCSR201812181BR',
--'IMCSR201812193BR',
--'IMCSR201812428BR',
--'IMCSR201812446BR',
--'IMCSR201901091BR',
--'IMCSR201901155BR',
--'IMCSR201901186BR',
--'IMCSR201901422BR',
--'IMCSR201901877BR',
--'IMCSR201902082BR',
--'IMCSR201902086BR',
--'IMCSR201902089BR',
--'IMCSR201902356BR',
--'IMCSR201902358BR',
--'IMCSR201902446BR',
--'IMCSR201902447BR',
--'IMCSR201902463BR',
--'IMCSR201902470BR',
--'IMCSR201902530BR',
--'IMCSR201902541BR',
--'IMCSR201902555BR',
--'IMCSR201902558BR',
--'IMCSR201902680BR',
--'IMCSR201902681BR',
--'IMCSR201902741BR',
--'IMCSR201902742BR',
--'IMCSR201902759BR',
--'IMCSR201903068BR',
--'IMCSR201903101BR',
--'IMCSR201903110BR',
--'IMCSR201903131BR',
--'IMCSR201903132BR',
--'IMCSR201903136BR',
--'IMCSR201903137BR',
--'IMCSR201903139BR',
--'IMCSR201904121BR',
--'IMCSR201904293BR',
--'IMCSR201904319BR',
--'IMCSR201904323BR',
--'IMCSR201905044BR',
--'IMCSR201905187BR',
--'IMCSR201905486BR',
--'IMCSR201906042BR',
--'IMCSR201906084BR',
--'IMCSR201906264BR',
--'IMCSR201906322BR',
--'IMCSR201906380BR',
--'IMCSR201906472BR',
--'IMCSR201906678BR',
--'IMCSR201907128BR',
--'IMCSR201907135BR',
--'IMCSR201907137BR',
--'IMCSR201907309BR',
--'IMCSR201907316BR',
--'IMCSR201907361BR',
--'IMCSR201907639BR',
--'IMCSR201907695BR',
--'IMCSR201907697BR',
--'IMCSR201907705BR',
--'IMCSR201907719BR',
--'IMCSR201907789BR',
--'IMCSR201907833BR',
--'IMCSR201907834BR',
--'IMCSR201907835BR',
--'IMCSR201907838BR',
--'IMCSR201908051BR',
--'IMCSR201908054BR',
--'IMCSR201908074BR',
--'IMCSR201908087BR',
--'IMCSR201908186BR',
--'IMCSR201908300BR',
--'IMCSR201908314BR',
--'IMCSR201908346BR',
--'IMCSR201908397BR',
--'IMCSR201908401BR',
--'IMCSR201908407BR',
--'IMCSR201908409BR',
--'IMCSR201909084BR',
--'IMCSR201909257BR',
--'IMCSR201909270BR',
--'IMCSR201909404BR',
--'IMCSR201909446BR',
--'IMCSR201909492BR',
--'IMCSR201910026BR',
--'IMCSR201910140BR',
--'IMCSR201910307BR',
--'IMCSR201910401BR',
--'IMCSR201910570BR',
--'IMCSR201911432BR',
--'IMCSR201911451BR',
--'IMCSR201911464BR',
--'IMCSR201911470BR',
--'IMCSR201911475BR',
--'IMCSR201912024BR',
--'IMCSR201912150BR',
--'IMCSR201912193BR',
--'IMCSR201912194BR',
--'IMCSR201912198BR',
--'IMCSR201912239BR',
--'IMCSR201912270BR',
--'IMCSR201912320BR',
--'IMCSR201912394BR',
--'IMCSR202001076BR',
--'IMCSR202001092BR',
--'IMCSR202001095BR',
--'IMCSR202001319BR',
--'IMCSR202001605BR',
--'IMCSR202001627BR',
--'IMCSR202001651BR',
--'IMCSR202001653BR',
--'IMCSR202002087BR',
--'IMCSR202002133BR',
--'IMCSR202002419BR',
--'IMCSR202002437BR',
--'IMCSR202003055BR',
--'IMCSR202003142BR',
--'IMCSR202003520BR',
--'IMCSR202003549BR',
--'IMCSR202004019BR',
--'IMCSR202004050BR',
--'IMCSR202004180BR',
--'IMCSR202004443BR',
--'IMCSR202004462BR',
--'IMCSR202004477BR',
--'IMCSR202004490BR',
--'IMCSR202004574BR',
--'IMCSR202004587BR',
--'IMCSR202004593BR',
--'IMCSR202005103BR',
--'IMCSR202005105BR',
--'IMCSR202005215BR',
--'IMCSR202005235BR',
--'IMCSR202005265BR',
--'IMCSR202005314BR',
--'IMCSR202005316BR',
--'IMCSR202005397BR',
--'IMCSR202005426BR',
--'IMCSR202005473BR',
--'IMCSR202006021BR',
--'IMCSR202006026BR',
--'IMCSR202006036BR',
--'IMCSR202006084BR',
--'IMCSR202006127BR',
--'IMCSR202006146BR',
--'IMCSR202006225BR',
--'IMCSR202006264BR',
--'IMCSR202006326BR',
--'IMCSR202006329BR',
--'IMCSR202007022BR',
--'IMCSR202007038BR',
--'IMCSR202007116BR',
--'IMCSR202007125BR',
--'IMCSR202007279BR',
--'IMCSR202007337BR',
--'IMCSR202007368BR',
--'IMCSR202008069BR',
--'IMCSR202008168BR',
--'IMCSR202008335BR',
--'IMCSR202009183BR',
--'IMCSR202009185BR',
--'IMCSR202009242BR',
--'IMCSR202009279BR',
--'IMCSR202009338BR',
--'IMCSR202009424BR',
--'IMCSR202009464BR',
--'IMCSR202009516BR',
--'IMCSR202009658BR',
--'IMCSR202009677BR',
--'IMCSR202009758BR',
--'IMCSR202009779BR',
--'IMCSR202009803BR',
--'IMCSR202010175BR',
--'IMCSR202010317BR',
--'IMCSR202010340BR',
--'IMCSR202010546BR',
--'IMCSR202011032BR',
--'IMCSR202011273BR',
--'IMCSR202012291BR',
--'IOCSR201809017BR',
--'IOCSR201809025BR',
--'IOCSR201909053BR',
--'IOCSR201910061BR',
--'IOCSR201912039BR'
--)                      
--order by  da.Id_DC 

--SELECT 	
--	UPPER(da.Num_Proc) Num_Proc,    
--	da.Id_DC  ,                
--	UPPER(nome_arquivo) nome_arquivo,  
--	'Documentos' pasta, 
--	UPPER(da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ','_'),'/','')) + '.pdf' NOME_DOC
--FROM doc_anexos DA (NOLOCK)
--INNER Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null
--WHERE da.Id_DC  in (16)                                                    
--and da.Num_Proc in ( 
--'IACTV202101005BR'
--)                      
--order by  da.Id_DC 

---##BKP CAMILA E JULIANA##--
--	select 
----top 10
--distinct 
--UPPER(da.Num_Proc)		Num_Proc                       
--,UPPER(nome_arquivo)		nome_arquivo                     
--,UPPER(da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','')) + '.pdf' NOME_DOC
--,case when SUBSTRING(upper(DA.Num_Proc),1,1) = 'I' 
--then 'Importação' 
--else 
--	case when SUBSTRING(upper(DA.Num_Proc),1,1) = 'E' then 'Exportação' else 'Outros' end  
--end as PASTA_01
--, convert(char(4),YEAR(dt_Conclusao)) as PASTA_02
--,CASE WHEN 
--	LEN(
--		ISNULL(	
--		replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(	
--		ltrim(rtrim(numero_po))	
--		,char(13)+char(10),''),char(10),''),'-',''),'.',''),'+',''),')',''),'(',''),'_',''),' ',''),'.',''),',',''),'#',''),':',''),'°','')
--		,'PO_NOT_FOUND_'+da.Num_Proc)
--		)<1
--	THEN
--		'PO_NOT_FOUND_'+da.Num_Proc
--	ELSE
--		ISNULL(
--		replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(	
--		ltrim(rtrim(numero_po))	
--		,char(13)+char(10),''),char(10),''),'-',''),'.',''),'+',''),')',''),'(',''),'_',''),' ',''),'.',''),',',''),'#',''),':',''),'°','')
--		,'PO_NOT_FOUND_'+da.Num_Proc)
--	END AS PASTA 
--,DMS_Code 
----into aux_ale
--FROM vwClienteALLJOBS V (NOLOCK)  
--INNER JOIN doc_anexos DA (NOLOCK)
--	on V.Num_Proc = DA.Num_Proc       
--INNER Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null 
--inner join tarefas_processos tp  (NOLOCK) on DA.Num_Proc =  tp.Num_Proc and id_Task=40
--left join vwPO PO with(nolock) on da.Num_Proc = PO.Num_proc and  PO.ID_DC = 1  
--join Pessoa_LLP LP on LP.cd_pes=  V.cd_cliente
--join Pessoa P on P.cd_pes = LP.cd_pes_grupo

----	

-- WHERE 

--tp.dt_Conclusao between '2023-01-01 00:00:00.000' and '2023-12-31 23:59:59.999'   
--and left (v.num_proc,1) = 'E'
--and P.Apelido = 'GRUPO OXITENO'


-- ORDER BY 

--case when SUBSTRING(upper(DA.Num_Proc),1,1) = 'I' 
--then 'Importação' 
--else 
--	case when SUBSTRING(upper(DA.Num_Proc),1,1) = 'E' then 'Exportação' else 'Outros' end  
--end 
--,convert(char(4),YEAR(dt_Conclusao)) 



        
--SET NOCOUNT OFF 

--select  distinct 
--	replacE(replacE(replace(PO.Numero_PO,' ',''),'/',''),'\','') as pasta ,
--	UPPER(nome_arquivo) nome_arquivo,
--	UPPER(DA.Num_Proc+'_'+REPLACE(TC.nome_dc,' ','')) + '.pdf' as NOME_DOC  ,    
--	da.Id_DC
--from vwClienteALLJOBS V (nolock)                 
--	join doc_anexos DA with(nolock) on V.Num_Proc = DA.Num_Proc   
--	Join Tipo_DoC_Cliente TC (nolock) on TC.id_dc=da.Id_DC
--	join vwPO PO (nolock) on V.Num_Proc =PO.Num_proc and PO.ID_DC = 3
--where
--	da.ID_DC in (2,8,10,11,13,20,60,81,103,130,178,204,236,258)
--	--da.ID_DC in(2,5,6,10,11,13,20,23,29,35,40,60,67,81,92,116,124,192)
--and V.Num_proc in 

-- order by 1 
--SET NOCOUNT OFF 

--select distinct 
--	da.Num_Proc,                       
--	nome_arquivo,                      
--	da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','') + '.pdf' NOME_DOC,                       
--	--(case when dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1) = '' or dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1) = '-' or dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1) = '.' then DA.Num_Proc else                      
--	--isnull(replace(replace(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1))),char(13)+char(10),''),char(10),''),'.',''),' ',''),'/',''),',','_'),'(',''),')',''),'-','_'),'PO_NotFound')                      
--	--end) pasta, 
	
--	CASE WHEN 
--	LEN(
--		ISNULL(
	
--		replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	
--		ltrim(rtrim(numero_po))
	
--		,char(13)+char(10),''),char(10),''),'-',''),'.',''),'+',''),')',''),'(',''),'_',''),' ',''),'.',''),',',''),'#',''),':',''),'°','')

--		,'PO_NOT_FOUND_'+da.Num_Proc)
--		)<1
--	THEN
--		'PO_NOT_FOUND_'+da.Num_Proc
--	ELSE

--		ISNULL(

--		replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	
--		ltrim(rtrim(numero_po))
	
--		,char(13)+char(10),''),char(10),''),'-',''),'.',''),'+',''),')',''),'(',''),'_',''),' ',''),'.',''),',',''),'#',''),':',''),'°','')

--		,'PO_NOT_FOUND_'+da.Num_Proc)

--	END AS pasta,
--	DMS_Code,              
--	F.Data_PC   
-- from doc_anexos DA with(nolock)                      
--	 Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null                      
--	 join Fatura_CHB F with(nolock) on left(F.Fatura_PC,16) = DA.Num_Proc 
--	 join vwPO PO with(nolock) on da.Num_Proc = PO.Num_proc and  PO.ID_DC = 1  
--where                      
--	year(F.Data_PC)= 2021                    
--	and SUBSTRING(DA.Num_Proc,3,3) ='OXT'                       
--	and  SUBSTRING(DA.Num_Proc,1,1) ='E'

--order by 4    

--select * from grupo where cd_pes_grupo in 
--(select cd_pes from Pessoa where Apelido in     
--('GRUPO SHERWIN'    
--,'GRUPO SOLENIS'       
--,'GRUPO CABOT'      
--,'GRUPO OXITENO'
--,'GRUPO EASTMAN'       
--,'GRUPO TAMINCO'      
--,'GRUPO SOLUTIA'
--)  
--)

--Select distinct 
--	UPPER(DA.Num_Proc) Num_Proc,
--	UPPER(DA.nome_arquivo) nome_arquivo, 
--	UPPER(da.Num_Proc + '_' + replace(replace([dbo].[FRemoveAcentuacao](TC.Nome_DC),' ',''),'/','')) + '.pdf' NOME_DOC, 
--	'Documentos' pasta,  
--	DA.Id_DC 
-- from vwClienteALLJOBS V (nolock)                   
--	left join doc_anexos	DA with(nolock) on V.Num_Proc = DA.Num_Proc                 
--	Join Tipo_DoC_Cliente	TC with(nolock) on TC.id_dc=da.Id_DC
--	join Pessoa_LLP LP on LP.cd_pes=  V.cd_cliente
--	join Pessoa P on P.cd_pes = LP.cd_pes_grupo
-- where 
--	P.Apelido = 'GRUPO OWENS CORNING' 
--	and DA.id_dc in (5,93)
--	and anexado_em between '2014-01-01' and '2021-12-31'

--select 
--	distinct UPPER(DA.Num_Proc) Num_Proc, 
--	 UPPER(DA.nome_arquivo) nome_arquivo,                      
--	 UPPER(da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','')) + '.pdf' NOME_DOC, 
--	'Documentos' pasta,  DA.Id_DC 
--	--,
--	--PL.cd_pes_grupo
--from doc_anexos DA
--	--join Pessoa P with(nolock) on P.cd_pes = V.cd_cliente
--	--join doc_anexos DA with(nolock) on DA.num_proc = V.num_proc and DA.id_dc = 5
--	Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC --and TC.DMS_Code is not null 
--	--join Pessoa_LLP PL on PL.cd_pes =  V.cd_cliente
--where 
-- DA.id_dc = 147 and
-- DA.Num_Proc in                      
--('IAEAS202008001BR')



--select distinct UPPER(da.Num_Proc) Num_Proc,                       
-- UPPER(nome_arquivo) nome_arquivo,                      
-- UPPER(da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','')) + '.pdf' NOME_DOC, 
--'Documentos' pasta,  
-- --replace(replace(case when po.Numero_PO = ''   then 'PONotFound'  else 
--	--(case when po.Numero_PO = '-' then 'PONotFound' else po.Numero_PO  end) end ,' ',''),'/','_')   pasta,
-- DMS_Code  ,da.Id_DC     
-- from doc_anexos DA with(nolock)                      
-- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null 
-- --left join vwPO PO with(nolock) on da.Num_Proc = PO.Num_proc and  PO.ID_DC = 5
--where                      
--   DA.Num_Proc in  
--  ('IMCSR201704676BR',)                     
--	and DA.ID_DC in (5)   
--order by 1,4





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
--   DA.Num_Proc in   ('IASPC202009015BR')                     
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
insert into #tmp_num_proc select  'IMOCV201711005BR'
insert into #tmp_num_proc select  'IMOCV201801013BR'
insert into #tmp_num_proc select  'IMOCV201801013BR'
insert into #tmp_num_proc select  'IMOCV201801009BR'
insert into #tmp_num_proc select  'IMOCV201801012BR'
insert into #tmp_num_proc select  'IMOCV201801012BR'
insert into #tmp_num_proc select  'IMOCV201801004BR'
insert into #tmp_num_proc select  'IMOCV201801004BR'
insert into #tmp_num_proc select  'IMOCV201711009BR'
insert into #tmp_num_proc select  'IMOCV201712006BR'
insert into #tmp_num_proc select  'IMOCV201801005BR'
insert into #tmp_num_proc select  'IMOCV201801002BR'
insert into #tmp_num_proc select  'IMOCV201801020BR'
insert into #tmp_num_proc select  'IMOCV201802001BR'
insert into #tmp_num_proc select  'IMOCV201803032BR'
insert into #tmp_num_proc select  'IAOCV201802003BR'
insert into #tmp_num_proc select  'IAOCV201803003BR'
insert into #tmp_num_proc select  'IMOCV201802004BR'
insert into #tmp_num_proc select  'IMOCV201802004BR'
insert into #tmp_num_proc select  'IMOCV201803019BR'
insert into #tmp_num_proc select  'IMOCV201803019BR'
insert into #tmp_num_proc select  'IMOCV201710006BR'
insert into #tmp_num_proc select  'IAOCV201803004BR'
insert into #tmp_num_proc select  'IMOCV201801016BR'
insert into #tmp_num_proc select  'IMOCV201801019BR'
insert into #tmp_num_proc select  'IMOCV201802002BR'
insert into #tmp_num_proc select  'IMOCV201803007BR'
insert into #tmp_num_proc select  'IAOCV201712001BR'
insert into #tmp_num_proc select  'IAOCV201804003BR'
insert into #tmp_num_proc select  'IMOCV201803023BR'
insert into #tmp_num_proc select  'IMOCV201803011BR'
insert into #tmp_num_proc select  'IAOCV201804001BR'
insert into #tmp_num_proc select  'IMOCV201801014BR'
insert into #tmp_num_proc select  'IAOCV201712003BR'
insert into #tmp_num_proc select  'IMOCV201803004BR'
insert into #tmp_num_proc select  'IMOCV201801015BR'
insert into #tmp_num_proc select  'IMOCV201801015BR'
insert into #tmp_num_proc select  'IMOCV201803022BR'
insert into #tmp_num_proc select  'IMOCV201803047BR'
insert into #tmp_num_proc select  'IMOCV201801003BR'
insert into #tmp_num_proc select  'IAOCV201804004BR'
insert into #tmp_num_proc select  'IMOCV201803029BR'
insert into #tmp_num_proc select  'IMOCV201803006BR'
insert into #tmp_num_proc select  'IMOCV201803009BR'
insert into #tmp_num_proc select  'IMOCV201803013BR'
insert into #tmp_num_proc select  'IMOCV201803048BR'
insert into #tmp_num_proc select  'IMOCV201803051BR'
insert into #tmp_num_proc select  'IMOCV201804004BR'
insert into #tmp_num_proc select  'IMOCV201804004BR'
insert into #tmp_num_proc select  'IMOCV201802008BR'
insert into #tmp_num_proc select  'IMOCV201802008BR'
insert into #tmp_num_proc select  'IMOCV201802006BR'
insert into #tmp_num_proc select  'IMOCV201802008BR'
insert into #tmp_num_proc select  'IMOCV201803018BR'
insert into #tmp_num_proc select  'IAOCV201805001BR'
insert into #tmp_num_proc select  'IAOCV201805001BR'
insert into #tmp_num_proc select  'IAOCV201803002BR'
insert into #tmp_num_proc select  'IAOCV201803002BR'
insert into #tmp_num_proc select  'IAOCV201803002BR'
insert into #tmp_num_proc select  'IAOCV201803002BR'
insert into #tmp_num_proc select  'IAOCV201803002BR'
insert into #tmp_num_proc select  'IAOCV201803002BR'
insert into #tmp_num_proc select  'IAOCV201803002BR'
insert into #tmp_num_proc select  'IMOCV201801017BR'
insert into #tmp_num_proc select  'IMOCV201803030BR'
insert into #tmp_num_proc select  'IMOCV201803037BR'
insert into #tmp_num_proc select  'IMOCV201803043BR'
insert into #tmp_num_proc select  'IMOCV201803044BR'
insert into #tmp_num_proc select  'IMOCV201804009BR'
insert into #tmp_num_proc select  'IAOCV201803001BR'
insert into #tmp_num_proc select  'IMOCV201803038BR'
insert into #tmp_num_proc select  'IMOCV201803038BR'
insert into #tmp_num_proc select  'IMOCV201803038BR'
insert into #tmp_num_proc select  'IMOCV201803016BR'
insert into #tmp_num_proc select  'IMOCV201803038BR'
insert into #tmp_num_proc select  'IMOCV201802007BR'
insert into #tmp_num_proc select  'IMOCV201802007BR'
insert into #tmp_num_proc select  'IAOCV201804002BR'
insert into #tmp_num_proc select  'IMOCV201803001BR'
insert into #tmp_num_proc select  'IMOCV201803052BR'
insert into #tmp_num_proc select  'IMOCV201803052BR'
insert into #tmp_num_proc select  'IMOCV201802009BR'
insert into #tmp_num_proc select  'IAOCV201805005BR'
insert into #tmp_num_proc select  'IAOCV201805005BR'
insert into #tmp_num_proc select  'IMOCV201803008BR'
insert into #tmp_num_proc select  'IAOCV201805003BR'
insert into #tmp_num_proc select  'IAOCV201805003BR'
insert into #tmp_num_proc select  'IAOCV201805003BR'
insert into #tmp_num_proc select  'IAOCV201805003BR'
insert into #tmp_num_proc select  'IAOCV201805003BR'
insert into #tmp_num_proc select  'IAOCV201805003BR'
insert into #tmp_num_proc select  'IMOCV201803005BR'
insert into #tmp_num_proc select  'IAOCV201709002BR'
insert into #tmp_num_proc select  'IMOCV201804014BR'
insert into #tmp_num_proc select  'IMOCV201805016BR'
insert into #tmp_num_proc select  'IMOCV201804015BR'
insert into #tmp_num_proc select  'IMOCV201802003BR'
insert into #tmp_num_proc select  'IMOCV201802003BR'
insert into #tmp_num_proc select  'IMOCV201805015BR'
insert into #tmp_num_proc select  'IMOCV201805015BR'
insert into #tmp_num_proc select  'IMOCV201804008BR'
insert into #tmp_num_proc select  'IMOCV201805006BR'
insert into #tmp_num_proc select  'IMOCV201805013BR'
insert into #tmp_num_proc select  'IMOCV201803025BR'
insert into #tmp_num_proc select  'IMOCV201803010BR'
insert into #tmp_num_proc select  'IMOCV201803003BR'
insert into #tmp_num_proc select  'IMOCV201805008BR'
insert into #tmp_num_proc select  'IMOCV201805009BR'
insert into #tmp_num_proc select  'IMOCV201806002BR'
insert into #tmp_num_proc select  'IMOCV201804006BR'
insert into #tmp_num_proc select  'IAOCV201805006BR'
insert into #tmp_num_proc select  'IAOCV201805006BR'
insert into #tmp_num_proc select  'IAOCV201805006BR'
insert into #tmp_num_proc select  'IMOCV201803039BR'
insert into #tmp_num_proc select  'IMOCV201803039BR'
insert into #tmp_num_proc select  'IMOCV201804002BR'
insert into #tmp_num_proc select  'IMOCV201804003BR'
insert into #tmp_num_proc select  'IMOCV201803027BR'
insert into #tmp_num_proc select  'IMOCV201805005BR'
insert into #tmp_num_proc select  'IMOCV201805005BR'
insert into #tmp_num_proc select  'IMOCV201805005BR'
insert into #tmp_num_proc select  'IAOCV201805004BR'
insert into #tmp_num_proc select  'IAOCV201807001BR'
insert into #tmp_num_proc select  'IMOCV201803017BR'
insert into #tmp_num_proc select  'IMOCV201804012BR'
insert into #tmp_num_proc select  'IMOCV201803026BR'
insert into #tmp_num_proc select  'IMOCV201806003BR'
insert into #tmp_num_proc select  'IMOCV201803002BR'
insert into #tmp_num_proc select  'IMOCV201803035BR'
insert into #tmp_num_proc select  'IMOCV201807003BR'
insert into #tmp_num_proc select  'IAOCV201807006BR'
insert into #tmp_num_proc select  'IMOCV201804001BR'
insert into #tmp_num_proc select  'IAOCV201805002BR'
insert into #tmp_num_proc select  'IMOCV201805007BR'
insert into #tmp_num_proc select  'IMOCV201805001BR'
insert into #tmp_num_proc select  'IAOCV201807004BR'
insert into #tmp_num_proc select  'IAOCV201807004BR'
insert into #tmp_num_proc select  'IMOCV201803021BR'
insert into #tmp_num_proc select  'IMOCV201803021BR'
insert into #tmp_num_proc select  'IAOCV201808001BR'
insert into #tmp_num_proc select  'IAOCV201808001BR'
insert into #tmp_num_proc select  'IAOCV201808001BR'
insert into #tmp_num_proc select  'IAOCV201808001BR'
insert into #tmp_num_proc select  'IAOCV201808001BR'
insert into #tmp_num_proc select  'IMOCV201803040BR'
insert into #tmp_num_proc select  'IMOCV201805002BR'
insert into #tmp_num_proc select  'IMOCV201807001BR'
insert into #tmp_num_proc select  'IAOCV201808003BR'
insert into #tmp_num_proc select  'IMOCV201805014BR'
insert into #tmp_num_proc select  'IMOCV201803033BR'
insert into #tmp_num_proc select  'IMOCV201804005BR'
insert into #tmp_num_proc select  'IMOCV201803041BR'
insert into #tmp_num_proc select  'IMOCV201805003BR'
insert into #tmp_num_proc select  'IMOCV201804010BR'
insert into #tmp_num_proc select  'IMOCV201805011BR'
insert into #tmp_num_proc select  'IMOCV201807004BR'
insert into #tmp_num_proc select  'IMOCV201804013BR'
insert into #tmp_num_proc select  'IMOCV201805011BR'
insert into #tmp_num_proc select  'IMOCV201805011BR'
insert into #tmp_num_proc select  'IAOCV201806001BR'
insert into #tmp_num_proc select  'IAOCV201806001BR'
insert into #tmp_num_proc select  'IAOCV201808002BR'
insert into #tmp_num_proc select  'IAOCV201808002BR'
insert into #tmp_num_proc select  'IAOCV201808002BR'
insert into #tmp_num_proc select  'IAOCV201808002BR'
insert into #tmp_num_proc select  'IAOCV201808002BR'
insert into #tmp_num_proc select  'IAOCV201808004BR'
insert into #tmp_num_proc select  'IMOCV201808004BR'
insert into #tmp_num_proc select  'IMOCV201808003BR'
insert into #tmp_num_proc select  'IMOCV201808005BR'
insert into #tmp_num_proc select  'IMOCV201808002BR'
insert into #tmp_num_proc select  'IMOCV201803020BR'
insert into #tmp_num_proc select  'IMOCV201804007BR'
insert into #tmp_num_proc select  'IMOCV201809004BR'
insert into #tmp_num_proc select  'IAOCV201809002BR'
insert into #tmp_num_proc select  'IMOCV201803012BR'
insert into #tmp_num_proc select  'IMOCV201809002BR'
insert into #tmp_num_proc select  'IMOCV201809003BR'
insert into #tmp_num_proc select  'IMOCV201808007BR'
insert into #tmp_num_proc select  'IMOCV201809001BR'
insert into #tmp_num_proc select  'IMOCV201804011BR'
insert into #tmp_num_proc select  'IMOCV201809005BR'
insert into #tmp_num_proc select  'IMOCV201805010BR'
insert into #tmp_num_proc select  'IAOCV201807002BR'
insert into #tmp_num_proc select  'IOOCV201809001BR'
insert into #tmp_num_proc select  'IOOCV201809001BR'
insert into #tmp_num_proc select  'IOOCV201809001BR'
insert into #tmp_num_proc select  'IOOCV201809001BR'
insert into #tmp_num_proc select  'IMOCV201802005BR'
insert into #tmp_num_proc select  'IMOCV201802005BR'
insert into #tmp_num_proc select  'IMOCV201810002BR'
insert into #tmp_num_proc select  'IMOCV201809011BR'
insert into #tmp_num_proc select  'IMOCV201808001BR'
insert into #tmp_num_proc select  'IMOCV201808001BR'
insert into #tmp_num_proc select  'IAOCV201810002BR'
insert into #tmp_num_proc select  'IMOCV201810001BR'
insert into #tmp_num_proc select  'IMOCV201809025BR'
insert into #tmp_num_proc select  'IMOCV201809024BR'
insert into #tmp_num_proc select  'IAOCV201810003BR'
insert into #tmp_num_proc select  'IMOCV201809009BR'
insert into #tmp_num_proc select  'IMOCV201809021BR'
insert into #tmp_num_proc select  'IMOCV201809021BR'
insert into #tmp_num_proc select  'IMOCV201809021BR'
insert into #tmp_num_proc select  'IMOCV201809023BR'
insert into #tmp_num_proc select  'IMOCV201809023BR'
insert into #tmp_num_proc select  'IMOCV201809007BR'
insert into #tmp_num_proc select  'IMOCV201806001BR'
insert into #tmp_num_proc select  'IMOCV201806001BR'
insert into #tmp_num_proc select  'IMOCV201806001BR'
insert into #tmp_num_proc select  'IMOCV201809020BR'
insert into #tmp_num_proc select  'IMOCV201809012BR'
insert into #tmp_num_proc select  'IMOCV201809013BR'
insert into #tmp_num_proc select  'IMOCV201809018BR'
insert into #tmp_num_proc select  'IMOCV201810005BR'
insert into #tmp_num_proc select  'IMOCV201810008BR'
insert into #tmp_num_proc select  'IMOCV201810007BR'
insert into #tmp_num_proc select  'IMOCV201810008BR'
insert into #tmp_num_proc select  'IMOCV201810008BR'
insert into #tmp_num_proc select  'IMOCV201809017BR'
insert into #tmp_num_proc select  'IMOCV201810007BR'
insert into #tmp_num_proc select  'IMOCV201810012BR'
insert into #tmp_num_proc select  'IMOCV201810021BR'
insert into #tmp_num_proc select  'IMOCV201810003BR'
insert into #tmp_num_proc select  'IMOCV201810012BR'
insert into #tmp_num_proc select  'IAOCV201811001BR'
insert into #tmp_num_proc select  'IMOCV201810031BR'
insert into #tmp_num_proc select  'IMOCV201811004BR'
insert into #tmp_num_proc select  'IMOCV201809022BR'
insert into #tmp_num_proc select  'IMOCV201809022BR'
insert into #tmp_num_proc select  'IMOCV201810027BR'
insert into #tmp_num_proc select  'IMOCV201808006BR'
insert into #tmp_num_proc select  'IMOCV201810030BR'
insert into #tmp_num_proc select  'IMOCV201809008BR'
insert into #tmp_num_proc select  'IMOCV201810016BR'
insert into #tmp_num_proc select  'IMOCV201810023BR'
insert into #tmp_num_proc select  'IMOCV201810018BR'
insert into #tmp_num_proc select  'IMOCV201809015BR'
insert into #tmp_num_proc select  'IMOCV201810026BR'
insert into #tmp_num_proc select  'IAOCV201810004BR'
insert into #tmp_num_proc select  'IMOCV201809010BR'
insert into #tmp_num_proc select  'IMOCV201810004BR'
insert into #tmp_num_proc select  'IMOCV201810004BR'
insert into #tmp_num_proc select  'IAOCV201811007BR'
insert into #tmp_num_proc select  'IAOCV201811004BR'
insert into #tmp_num_proc select  'IAOCV201811003BR'
insert into #tmp_num_proc select  'IAOCV201811003BR'
insert into #tmp_num_proc select  'IMOCV201805012BR'
insert into #tmp_num_proc select  'IMOCV201810011BR'
insert into #tmp_num_proc select  'IMOCV201810024BR'
insert into #tmp_num_proc select  'IMOCV201810017BR'
insert into #tmp_num_proc select  'IMOCV201809019BR'
insert into #tmp_num_proc select  'IMOCV201812002BR'
insert into #tmp_num_proc select  'IMOCV201812002BR'
insert into #tmp_num_proc select  'IMOCV201812001BR'
insert into #tmp_num_proc select  'IMOCV201810028BR'
insert into #tmp_num_proc select  'IAOCV201812003BR'
insert into #tmp_num_proc select  'IMOCV201810013BR'
insert into #tmp_num_proc select  'IAOCV201811009BR'
insert into #tmp_num_proc select  'IMOCV201810019BR'
insert into #tmp_num_proc select  'IAOCV201812001BR'
insert into #tmp_num_proc select  'IMOCV201810009BR'
insert into #tmp_num_proc select  'IMOCV201810025BR'
insert into #tmp_num_proc select  'IMOCV201809006BR'
insert into #tmp_num_proc select  'IMOCV201809014BR'
insert into #tmp_num_proc select  'IMOCV201811005BR'
insert into #tmp_num_proc select  'IMOCV201809016BR'
insert into #tmp_num_proc select  'IAOCV201812004BR'
insert into #tmp_num_proc select  'IMOCV201810022BR'
insert into #tmp_num_proc select  'IMOCV201810022BR'
insert into #tmp_num_proc select  'IMOCV201810006BR'
insert into #tmp_num_proc select  'IMOCV201810006BR'
insert into #tmp_num_proc select  'IMOCV201810006BR'
insert into #tmp_num_proc select  'IMOCV201810020BR'
insert into #tmp_num_proc select  'IAOCV201812005BR'
insert into #tmp_num_proc select  'IMOCV201811002BR'
insert into #tmp_num_proc select  'IMOCV201803015BR'
insert into #tmp_num_proc select  'IMOCV201810010BR'
insert into #tmp_num_proc select  'IMOCV201811010BR'
insert into #tmp_num_proc select  'IMOCV201811011BR'
insert into #tmp_num_proc select  'IMOCV201811009BR'
insert into #tmp_num_proc select  'IMOCV201811008BR'
insert into #tmp_num_proc select  'IMOCV201810029BR'
insert into #tmp_num_proc select  'IAOCV201901012BR'
insert into #tmp_num_proc select  'IMOCV201811007BR'
insert into #tmp_num_proc select  'IAOCV201811008BR'
insert into #tmp_num_proc select  'IAOCV201901013BR'
insert into #tmp_num_proc select  'IAOCV201810001BR'
insert into #tmp_num_proc select  'IAOCV201901007BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IMOCV201803014BR'
insert into #tmp_num_proc select  'IAOCV201811005BR'
insert into #tmp_num_proc select  'IAOCV201902003BR'
insert into #tmp_num_proc select  'IMOCV201812005BR'
insert into #tmp_num_proc select  'IAOCV201901001BR'
insert into #tmp_num_proc select  'IAOCV201901001BR'
insert into #tmp_num_proc select  'IAOCV201901001BR'
insert into #tmp_num_proc select  'IAOCV201901008BR'
insert into #tmp_num_proc select  'IMOCV201901002BR'
insert into #tmp_num_proc select  'IMOCV201901002BR'
insert into #tmp_num_proc select  'IMOCV201901003BR'
insert into #tmp_num_proc select  'IMOCV201901003BR'
insert into #tmp_num_proc select  'IAOCV201901002BR'
insert into #tmp_num_proc select  'IMOCV201901021BR'
insert into #tmp_num_proc select  'IMOCV201901021BR'
insert into #tmp_num_proc select  'IMOCV201901021BR'
insert into #tmp_num_proc select  'IMOCV201812006BR'
insert into #tmp_num_proc select  'IMOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901005BR'
insert into #tmp_num_proc select  'IAOCV201902004BR'
insert into #tmp_num_proc select  'IAOCV201901005BR'
insert into #tmp_num_proc select  'IAOCV201902004BR'
insert into #tmp_num_proc select  'IAOCV201902007BR'
insert into #tmp_num_proc select  'IMOCV201901005BR'
insert into #tmp_num_proc select  'IMOCV201901022BR'
insert into #tmp_num_proc select  'IMOCV201901017BR'
insert into #tmp_num_proc select  'IMOCV201810014BR'
insert into #tmp_num_proc select  'IMOCV201901008BR'
insert into #tmp_num_proc select  'IMOCV201901008BR'
insert into #tmp_num_proc select  'IMOCV201901011BR'
insert into #tmp_num_proc select  'IAOCV201902006BR'
insert into #tmp_num_proc select  'IAOCV201902006BR'
insert into #tmp_num_proc select  'IMOCV201901009BR'
insert into #tmp_num_proc select  'IMOCV201903001BR'
insert into #tmp_num_proc select  'IMOCV201901006BR'
insert into #tmp_num_proc select  'IMOCV201901016BR'
insert into #tmp_num_proc select  'IMOCV201902002BR'
insert into #tmp_num_proc select  'IMOCV201901013BR'
insert into #tmp_num_proc select  'IMOCV201901018BR'
insert into #tmp_num_proc select  'IMOCV201901013BR'
insert into #tmp_num_proc select  'IMOCV201901013BR'
insert into #tmp_num_proc select  'IAOCV201903004BR'
insert into #tmp_num_proc select  'IMOCV201903004BR'
insert into #tmp_num_proc select  'IAOCV201901011BR'
insert into #tmp_num_proc select  'IMOCV201902001BR'
insert into #tmp_num_proc select  'IMOCV201902006BR'
insert into #tmp_num_proc select  'IMOCV201902001BR'
insert into #tmp_num_proc select  'IMOCV201901014BR'
insert into #tmp_num_proc select  'IMOCV201902009BR'
insert into #tmp_num_proc select  'IMOCV201902005BR'
insert into #tmp_num_proc select  'IMOCV201902003BR'
insert into #tmp_num_proc select  'IMOCV201901007BR'
insert into #tmp_num_proc select  'IMOCV201902013BR'
insert into #tmp_num_proc select  'IAOCV201903005BR'
insert into #tmp_num_proc select  'IAOCV201903005BR'
insert into #tmp_num_proc select  'IAOCV201903005BR'
insert into #tmp_num_proc select  'IAOCV201904001BR'
insert into #tmp_num_proc select  'IMOCV201901010BR'
insert into #tmp_num_proc select  'IMOCV201902016BR'
insert into #tmp_num_proc select  'IMOCV201902016BR'
insert into #tmp_num_proc select  'IMOCV201902016BR'
insert into #tmp_num_proc select  'IAOCV201901003BR'
insert into #tmp_num_proc select  'IAOCV201901003BR'
insert into #tmp_num_proc select  'IAOCV201904002BR'
insert into #tmp_num_proc select  'IMOCV201903006BR'
insert into #tmp_num_proc select  'IMOCV201902010BR'
insert into #tmp_num_proc select  'IMOCV201903005BR'
insert into #tmp_num_proc select  'IAOCV201902002BR'
insert into #tmp_num_proc select  'IAOCV201812002BR'
insert into #tmp_num_proc select  'IAOCV201901010BR'
insert into #tmp_num_proc select  'IAOCV201901006BR'
insert into #tmp_num_proc select  'IMOCV201902015BR'
insert into #tmp_num_proc select  'IAOCV201811002BR'
insert into #tmp_num_proc select  'IAOCV201811002BR'
insert into #tmp_num_proc select  'IAOCV201903001BR'
insert into #tmp_num_proc select  'IAOCV201904009BR'
insert into #tmp_num_proc select  'IMOCV201901012BR'
insert into #tmp_num_proc select  'IMOCV201902004BR'
insert into #tmp_num_proc select  'IAOCV201904003BR'
insert into #tmp_num_proc select  'IMOCV201902008BR'
insert into #tmp_num_proc select  'IMOCV201904012BR'
insert into #tmp_num_proc select  'IMOCV201902011BR'
insert into #tmp_num_proc select  'IAOCV201901009BR'
insert into #tmp_num_proc select  'IMOCV201902014BR'
insert into #tmp_num_proc select  'IMOCV201903008BR'
insert into #tmp_num_proc select  'IMOCV201904011BR'
insert into #tmp_num_proc select  'IMOCV201902012BR'
insert into #tmp_num_proc select  'IAOCV201901014BR'
insert into #tmp_num_proc select  'IAOCV201901014BR'
insert into #tmp_num_proc select  'IAOCV201901014BR'
insert into #tmp_num_proc select  'IMOCV201904013BR'
insert into #tmp_num_proc select  'IAOCV201904008BR'
insert into #tmp_num_proc select  'IMOCV201903009BR'
insert into #tmp_num_proc select  'IMOCV201903009BR'
insert into #tmp_num_proc select  'IMOCV201903002BR'
insert into #tmp_num_proc select  'IAOCV201903007BR'
insert into #tmp_num_proc select  'IAOCV201904010BR'
insert into #tmp_num_proc select  'IAOCV201904010BR'
insert into #tmp_num_proc select  'IAOCV201905007BR'
insert into #tmp_num_proc select  'IMOCV201904001BR'
insert into #tmp_num_proc select  'IAOCV201905013BR'
insert into #tmp_num_proc select  'IAOCV201905013BR'
insert into #tmp_num_proc select  'IMOCV201903003BR'
insert into #tmp_num_proc select  'IMOCV201903007BR'
insert into #tmp_num_proc select  'IMOCV201903007BR'
insert into #tmp_num_proc select  'IAOCV201903006BR'
insert into #tmp_num_proc select  'IAOCV201903006BR'
insert into #tmp_num_proc select  'IAOCV201903006BR'
insert into #tmp_num_proc select  'IAOCV201903006BR'
insert into #tmp_num_proc select  'IAOCV201903006BR'
insert into #tmp_num_proc select  'IAOCV201904006BR'
insert into #tmp_num_proc select  'IMOCV201905008BR'
insert into #tmp_num_proc select  'IMOCV201905009BR'
insert into #tmp_num_proc select  'IAOCV201905004BR'
insert into #tmp_num_proc select  'IAOCV201905003BR'
insert into #tmp_num_proc select  'IAOCV201905005BR'
insert into #tmp_num_proc select  'IAOCV201905005BR'
insert into #tmp_num_proc select  'IMOCV201901019BR'
insert into #tmp_num_proc select  'IMOCV201902007BR'
insert into #tmp_num_proc select  'IMOCV201904017BR'
insert into #tmp_num_proc select  'IAOCV201904011BR'
insert into #tmp_num_proc select  'IMOCV201904015BR'
insert into #tmp_num_proc select  'IMOCV201904002BR'
insert into #tmp_num_proc select  'IMOCV201904015BR'
insert into #tmp_num_proc select  'IAOCV201906006BR'
insert into #tmp_num_proc select  'IAOCV201906006BR'
insert into #tmp_num_proc select  'IAOCV201905014BR'
insert into #tmp_num_proc select  'IAOCV201905014BR'
insert into #tmp_num_proc select  'IAOCV201905014BR'
insert into #tmp_num_proc select  'IAOCV201905001BR'
insert into #tmp_num_proc select  'IMOCV201904007BR'
insert into #tmp_num_proc select  'IAOCV201906008BR'
insert into #tmp_num_proc select  'IAOCV201906009BR'
insert into #tmp_num_proc select  'IAOCV201904012BR'
insert into #tmp_num_proc select  'IAOCV201906003BR'
insert into #tmp_num_proc select  'IAOCV201906011BR'
insert into #tmp_num_proc select  'IMOCV201905003BR'
insert into #tmp_num_proc select  'IMOCV201905018BR'
insert into #tmp_num_proc select  'IAOCV201905010BR'
insert into #tmp_num_proc select  'IMOCV201905005BR'
insert into #tmp_num_proc select  'IMOCV201906001BR'
insert into #tmp_num_proc select  'IMOCV201905007BR'
insert into #tmp_num_proc select  'IMOCV201905007BR'
insert into #tmp_num_proc select  'IAOCV201907001BR'
insert into #tmp_num_proc select  'IMOCV201905015BR'
insert into #tmp_num_proc select  'IMOCV201904006BR'
insert into #tmp_num_proc select  'IMOCV201904008BR'
insert into #tmp_num_proc select  'IMOCV201905012BR'
insert into #tmp_num_proc select  'IMOCV201904003BR'
insert into #tmp_num_proc select  'IAOCV201906001BR'
insert into #tmp_num_proc select  'IAOCV201906001BR'
insert into #tmp_num_proc select  'IAOCV201905008BR'
insert into #tmp_num_proc select  'IMOCV201905013BR'
insert into #tmp_num_proc select  'IMOCV201905016BR'
insert into #tmp_num_proc select  'IAOCV201905009BR'
insert into #tmp_num_proc select  'IAOCV201905015BR'
insert into #tmp_num_proc select  'IAOCV201906010BR'
insert into #tmp_num_proc select  'IAOCV201903003BR'
insert into #tmp_num_proc select  'IMOCV201905019BR'
insert into #tmp_num_proc select  'IMOCV201905017BR'
insert into #tmp_num_proc select  'IMOCV201905017BR'
insert into #tmp_num_proc select  'IMOCV201906005BR'
insert into #tmp_num_proc select  'IMOCV201906003BR'
insert into #tmp_num_proc select  'IAOCV201902001BR'
insert into #tmp_num_proc select  'IAOCV201907011BR'
insert into #tmp_num_proc select  'IMOCV201906008BR'
insert into #tmp_num_proc select  'IMOCV201904016BR'
insert into #tmp_num_proc select  'IMOCV201906013BR'
insert into #tmp_num_proc select  'IMOCV201906016BR'
insert into #tmp_num_proc select  'IMOCV201906015BR'
insert into #tmp_num_proc select  'IMOCV201906017BR'
insert into #tmp_num_proc select  'IMOCV201906017BR'
insert into #tmp_num_proc select  'IMOCV201906014BR'
insert into #tmp_num_proc select  'IMOCV201906012BR'
insert into #tmp_num_proc select  'IAOCV201904004BR'
insert into #tmp_num_proc select  'IAOCV201907010BR'
insert into #tmp_num_proc select  'IAOCV201906012BR'
insert into #tmp_num_proc select  'IAOCV201906012BR'
insert into #tmp_num_proc select  'IAOCV201908002BR'
insert into #tmp_num_proc select  'IAOCV201906012BR'
insert into #tmp_num_proc select  'IAOCV201906012BR'
insert into #tmp_num_proc select  'IAOCV201906012BR'
insert into #tmp_num_proc select  'IAOCV201906012BR'
insert into #tmp_num_proc select  'IMOCV201906011BR'
insert into #tmp_num_proc select  'IMOCV201906006BR'
insert into #tmp_num_proc select  'IMOCV201906019BR'
insert into #tmp_num_proc select  'IMOCV201906019BR'
insert into #tmp_num_proc select  'IAOCV201908003BR'
insert into #tmp_num_proc select  'IMOCV201907009BR'
insert into #tmp_num_proc select  'IMOCV201907009BR'
insert into #tmp_num_proc select  'IMOCV201907009BR'
insert into #tmp_num_proc select  'IAOCV201907007BR'
insert into #tmp_num_proc select  'IAOCV201908005BR'
insert into #tmp_num_proc select  'IAOCV201908005BR'
insert into #tmp_num_proc select  'IAOCV201908004BR'
insert into #tmp_num_proc select  'IMOCV201906007BR'
insert into #tmp_num_proc select  'IMOCV201908003BR'
insert into #tmp_num_proc select  'IMOCV201907006BR'
insert into #tmp_num_proc select  'IMOCV201906020BR'
insert into #tmp_num_proc select  'IMOCV201906020BR'
insert into #tmp_num_proc select  'IMOCV201907001BR'
insert into #tmp_num_proc select  'IMOCV201905014BR'
insert into #tmp_num_proc select  'IMOCV201908009BR'
insert into #tmp_num_proc select  'IMOCV201907010BR'
insert into #tmp_num_proc select  'IMOCV201906009BR'
insert into #tmp_num_proc select  'IMOCV201907003BR'
insert into #tmp_num_proc select  'IAOCV201905011BR'
insert into #tmp_num_proc select  'IAOCV201907005BR'
insert into #tmp_num_proc select  'IAOCV201907006BR'
insert into #tmp_num_proc select  'IAOCV201907009BR'
insert into #tmp_num_proc select  'IMOCV201907008BR'
insert into #tmp_num_proc select  'IAOCV201907004BR'
insert into #tmp_num_proc select  'IAOCV201907004BR'
insert into #tmp_num_proc select  'IMOCV201908006BR'
insert into #tmp_num_proc select  'IMOCV201908006BR'
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
insert into #tmp_num_proc select  'EMCSR201901092BR'  
insert into #tmp_num_proc select  'EMCSR201902082BR'  
insert into #tmp_num_proc select  'EMCSR201902037BR'  
insert into #tmp_num_proc select  'EMCSR201903005BR'  
insert into #tmp_num_proc select  'EMCSR201902035BR'  
insert into #tmp_num_proc select  'EMCSR201903006BR'  
insert into #tmp_num_proc select  'EMCSR201902080BR'  
insert into #tmp_num_proc select  'EMCSR201903007BR'  
insert into #tmp_num_proc select  'EMCSR201903072BR'  
insert into #tmp_num_proc select  'EMCSR201902079BR'  
insert into #tmp_num_proc select  'EMCSR201903074BR'  
insert into #tmp_num_proc select  'EOCSR201910014BR'  
insert into #tmp_num_proc select  'EMCSR201903075BR'  
insert into #tmp_num_proc select  'EOCSR201908021BR'  
insert into #tmp_num_proc select  'EACSR201910005BR'  
insert into #tmp_num_proc select  'EMCSR201903076BR'  
insert into #tmp_num_proc select  'EMCSR201905040BR'  
insert into #tmp_num_proc select  'EMCSR201812095BR'  
insert into #tmp_num_proc select  'EACSR201907002BR'  
insert into #tmp_num_proc select  'EOCSR201902001BR'  
insert into #tmp_num_proc select  'EOCSR201907050BR'  
insert into #tmp_num_proc select  'EOCSR201907052BR'  
insert into #tmp_num_proc select  'EOCSR201907039BR'  
insert into #tmp_num_proc select  'EOCSR201907040BR'  
insert into #tmp_num_proc select  'EOCSR201908018BR'  
insert into #tmp_num_proc select  'EOCSR201910001BR'  
insert into #tmp_num_proc select  'EOCSR201908019BR'  
insert into #tmp_num_proc select  'EOCSR201909005BR'  
insert into #tmp_num_proc select  'EMCSR201904003BR'  
insert into #tmp_num_proc select  'EOCSR201909001BR'  
insert into #tmp_num_proc select  'EACSR201901003BR'  
insert into #tmp_num_proc select  'EOCSR201907042BR'  
insert into #tmp_num_proc select  'EOCSR201910002BR'  
insert into #tmp_num_proc select  'EOCSR201907001BR'  
insert into #tmp_num_proc select  'EOCSR201909021BR'  
insert into #tmp_num_proc select  'EACSR201910002BR'  
insert into #tmp_num_proc select  'EOCSR201909020BR'  
insert into #tmp_num_proc select  'EOCSR201907041BR'  
insert into #tmp_num_proc select  'EOCSR201911002BR'  
insert into #tmp_num_proc select  'EMCSR201911086BR'  
insert into #tmp_num_proc select  'EOCSR201911005BR'  
insert into #tmp_num_proc select  'EOCSR201911006BR'  
insert into #tmp_num_proc select  'EOCSR201911007BR'  
insert into #tmp_num_proc select  'EOCSR201908003BR'  
insert into #tmp_num_proc select  'EMCSR201905052BR'  
insert into #tmp_num_proc select  'EMCSR202002036BR'  
insert into #tmp_num_proc select  'EMCSR201904074BR'  
insert into #tmp_num_proc select  'EMCSR201904075BR'  
insert into #tmp_num_proc select  'EMCSR201905001BR'  
insert into #tmp_num_proc select  'EACSR201911001BR'  
insert into #tmp_num_proc select  'EMCSR201901069BR'  
insert into #tmp_num_proc select  'EMCSR201902106BR'  
insert into #tmp_num_proc select  'EMCSR202001072BR'  
  
    
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
create table #tmp_num_proc           
(          
numero_po varchar(16) COLLATE Latin1_General_CI_AI           
,num_proc varchar(16) COLLATE Latin1_General_CI_AI           
)             
         
if 1 = 1         
begin        
 insert into #tmp_num_proc select  'xxxxxx','IMKRY201602008BR'    
 insert into #tmp_num_proc select  'xxxxxx','IMKRY201602004BR'    
 insert into #tmp_num_proc select  'xxxxxx','IMKRY201602013BR'    
 insert into #tmp_num_proc select  'xxxxxx','EAMTE201708001BR'    
 insert into #tmp_num_proc select  'xxxxxx','EAMTE201709001BR'    
 insert into #tmp_num_proc select  'xxxxxx','EAMTE201710001BR'    
 insert into #tmp_num_proc select  'xxxxxx','EAMTE201712001BR'    
 insert into #tmp_num_proc select  'xxxxxx','EAMTE201801002BR'    
 insert into #tmp_num_proc select  'xxxxxx','EAMTE201801003BR'    
 insert into #tmp_num_proc select  'xxxxxx','EAMAU201512001BR'    
 insert into #tmp_num_proc select  'xxxxxx','EACSR201703007BR'    
 insert into #tmp_num_proc select  'xxxxxx','EAMTE201707002BR'    
end         
           
                  
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
 insert into #tmp_num_proc select  'xxxxxx','IAATL201711049BR'        
 insert into #tmp_num_proc select  'xxxxxx','IAATL201708047BR'        
 insert into #tmp_num_proc select  'xxxxxx','IAFUN201708001BR'        
 insert into #tmp_num_proc select  'xxxxxx','IAATL201706042BR'        
 insert into #tmp_num_proc select  'xxxxxx','IACSR201709010BR'        
 insert into #tmp_num_proc select  'xxxxxx','IANVS201706001BR'        
 insert into #tmp_num_proc select  'xxxxxx','IACSR201703059BR'        
 insert into #tmp_num_proc select  'xxxxxx','IACSR201602022BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201703055BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201703054BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201703023BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201702009BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201702008BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201702007BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201608014BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201606045BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201603011BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201604001BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201602021BR'        
 insert into #tmp_num_proc select  'xxxxxx','EAOSR201712001BR'        
 insert into #tmp_num_proc select  'xxxxxx','EASYN201603001BR'        
 insert into #tmp_num_proc select  'xxxxxx','EAOSR201611001BR'        
 insert into #tmp_num_proc select  'xxxxxx','EAOSR201611002BR'        
 insert into #tmp_num_proc select  'xxxxxx','EASGB201702001BR'        
 insert into #tmp_num_proc select  'xxxxxx','EASGB201702002BR'        
 insert into #tmp_num_proc select  'xxxxxx','EASGB201702003BR'        
 insert into #tmp_num_proc select  'xxxxxx','EASGB201709001BR'        
 insert into #tmp_num_proc select  'xxxxxx','EASGB201712001BR'        
 insert into #tmp_num_proc select  'xxxxxx','EASGB201710002BR'        
 insert into #tmp_num_proc select  'xxxxxx','EASGB201710003BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201602002BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201601007BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201603026BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMBCB201603006BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201602006BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMAMZ201603008BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMBCB201605002BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201602005BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMFMC201609001BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201610007BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201610023BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201612031BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201703018BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMBCB201703002BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201705034BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201706030BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201709004BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201710018BR'        
 insert into #tmp_num_proc select  'xxxxxx','IAAPB201801006BR '        
 insert into #tmp_num_proc select  'xxxxxx','IACSR201712066BR'        
 insert into #tmp_num_proc select  'xxxxxx','IACSR201706024BR'        
        
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
