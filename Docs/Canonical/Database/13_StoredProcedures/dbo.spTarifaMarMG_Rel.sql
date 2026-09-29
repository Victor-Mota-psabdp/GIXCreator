SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










CREATE        Procedure spTarifaMarMG_Rel

as


select 
	tm.tptid, TA.TAMID Codigo,Nome_Armador, TA.TAMID, org.nome_local Origem, org.pais_local,dst.nome_local Destino,tAMfreq Frequencia, tAMtTime Transit, TA.cd_tp_moeda,tt.cd_Tp_cont,TTMVLRCOMP,TAMDtVal,TTMBAF,dst.Pais_Local, TM.*
from 
	tar_MAR TA
	Join Localidade Org on org.cd_local=tamcdorg
	Join Localidade dst on dst.cd_local=tamcddst
	Join tar_tar_mar TT on tt.tAmid=ta.tAmid
	Join Armador ARM on ARM.cd_armador=TA.cd_armador
	join tipo_tarif_rang_mar TM on tm.tptid = 7 and tt.cd_tp_cont = tm.cd_tp_cont

where 
	ta.tptid=6 and TAMdtVal >= getdate() +3 AND tt.CD_TP_CONT NOT IN ('LCL','LCM')







GO
