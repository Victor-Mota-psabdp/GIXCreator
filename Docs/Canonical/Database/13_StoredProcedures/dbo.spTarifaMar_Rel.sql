SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






CREATE    Procedure spTarifaMar_Rel

as


select 
	TA.TAMID Codigo,Nome_Armador, TA.TAMID, org.nome_local Origem,dst.nome_local Destino,tAMfreq Frequencia, tAMtTime Transit, TA.cd_tp_moeda,cd_Tp_cont,TTMVLRVND,TAMDtVal,TTMBAF,dst.Pais_Local
from 
	tar_MAR TA
	Join Localidade Org on org.cd_local=tamcdorg
	Join Localidade dst on dst.cd_local=tamcddst
	Join tar_tar_mar TT on tt.tAmid=ta.tAmid
	Join Armador ARM on ARM.cd_armador=TA.cd_armador
where 
	tptid=6 and TAMdtVal >= getdate() +3 AND CD_TP_CONT NOT IN ('LCL','LCM')







GO
