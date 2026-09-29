SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





CREATE        Procedure spTarifaAerMG_Rel
as

select 
	TA.TAEID, org.nome_local Origem,dst.nome_local Destino,taefreq Frequencia, taetTime Transit, TA.cd_tp_moeda,TTARangMax,TTAVLRComp,TAEDtVal,tx.TxAValor,ts.TxAValor SCC,dst.pais_local, TR.*
 
from 
	tar_aer TA
	Join Localidade Org on org.cd_local=taecdorg
	Join Localidade dst on dst.cd_local=taecddst
	Join tar_tar_aer TT on tt.taeid=ta.taeid
	Join tax_tar_aer TX on TX.Taeid=TA.taeid and tx.cd_tp_tx='FSC'
	join tipo_tarif_rang_aer TR on TR.tptID =7
	Left Join Tax_tar_Aer TS on ta.taeid=TS.taeid and ts.cd_tp_tx='SEC'
where 
	TA.tptid=6 and TAEDtVAl > = getdate() +3




GO
