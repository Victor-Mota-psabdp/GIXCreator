SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







CREATE        Procedure spTarifaAer_Rel

as

select 
	TA.TAEID, UPPER(taecdorg) CD_Org,org.nome_local Origem,Upper(taecddst) cd_Dst,dst.nome_local Destino,dst.bitri,taefreq Frequencia, taetTime Transit, TA.cd_tp_moeda,TTARangMax,TTAVLRVND,TAEDtVal,tx.TxAValor,ts.TxAValor SCC,dst.pais_local
 
from 
	tar_aer TA
	Join Localidade Org on org.cd_local=taecdorg
	Join Localidade dst on dst.cd_local=taecddst
	Join tar_tar_aer TT on tt.taeid=ta.taeid
	Left Join tax_tar_aer TX on TX.Taeid=TA.taeid and tx.cd_tp_tx='FSC'
	Left Join Tax_tar_Aer TS on ta.taeid=TS.taeid and ts.cd_tp_tx='SEC'
where 
	 TAEDtVAl > = getdate() +3 and tptid=3




GO
