SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






CREATE  Procedure spTarifaMarLCL_Rel

as


select 
	TA.TAMID, org.nome_local Origem,dst.nome_local Destino, via.nome_local Local_VIA, tAMfreq Frequencia, tAMtTime Transit, TA.cd_tp_moeda,cd_Tp_cont,TTMVLRVND,TAMDtVal,TTMBAF,dst.Pais_Local
from 
	tar_MAR TA
	Join Localidade Org on org.cd_local=tamcdorg
	Join Localidade dst on dst.cd_local=tamcddst
	Join tar_tar_mar TT on tt.tAmid=ta.tAmid
	join Localidade VIA on via.cd_local=TAMCdVia
where 
	tptid=6 and cd_tp_cont in ('LCL', 'LCM') and TAMdtVal >= getdate() +3 








GO
