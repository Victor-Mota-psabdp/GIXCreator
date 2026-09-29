SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO











CREATE            procedure spTarifaAerTX_REL 
		(
			@Modal varchar(1)
		)
as

if @Modal='A' 
	BEGIN 
		select 
		  Nome_tp_Tx, TX.cd_tp_moeda, txaValor Valor,TXAEspec Espec,org.Nome_local Origem, 
		  dst.nome_local Destino,TAEDtVal,dst.Pais_Local
		from 
		  tax_tar_Aer TX
		  Join Tipo_Taxa TT on TT.cd_tp_Tx=TX.cd_tp_Tx
		  Join Tar_Aer TA on TA.TAEID=TX.TAEID
		  Join Localidade Org on org.cd_local=taecdorg
		  Join Localidade dst on dst.cd_local=taecddst
		Where 
		   TX.cd_tp_Tx not in ('FSC','SEC') and tptid=6  AND
		   TaeDtVal > = getdate()+3

                Group by
        	  Nome_tp_Tx, TX.cd_tp_moeda, txaValor,TXAEspec,org.Nome_local, 
		  dst.nome_local,TAEDtVal,dst.Pais_Local
        END
ELSE
  if @MODAL='M'	
	BEGIN
		select 
		  Nome_tp_Tx, TX.cd_tp_moeda, txmValor Valor,TXMEspec Espec,org.Nome_local Origem, 
		  dst.nome_local Destino,TAMDtVal,dst.Pais_Local
		from 
		  tax_tar_MAR TX
		  Join Tipo_Taxa TT on TT.cd_tp_Tx=TX.cd_tp_Tx
		  Join Tar_MAR TA on TA.TAMID=TX.TAMID
		  Join Localidade Org on org.cd_local=taMcdorg
		  Join Localidade dst on dst.cd_local=taMcddst
		  Join Tar_Tar_Mar TTM on TTM.TAMID=TX.TAMID
		Where 
		   tptid=6 and cd_Tp_cont not in ('LCL') and TAMdtVal >= getdate() +3 
		Group by
		  Nome_tp_Tx, TX.cd_tp_moeda, txmValor,TXMEspec,org.Nome_local, 
		  dst.nome_local,TAMDtVal,dst.Pais_Local
	END
   else
	BEGIN
		select 
		  Nome_tp_Tx, TX.cd_tp_moeda, txmValor Valor,TXMEspec Espec,org.Nome_local Origem, 
		  dst.nome_local Destino,TAMDtVal,dst.Pais_Local
		from 
		  tax_tar_MAR TX
		  Join Tipo_Taxa TT on TT.cd_tp_Tx=TX.cd_tp_Tx
		  Join Tar_MAR TA on TA.TAMID=TX.TAMID
		  Join Localidade Org on org.cd_local=taMcdorg
		  Join Localidade dst on dst.cd_local=taMcddst
		  Join Tar_Tar_Mar TTM on TTM.TAMID=TX.TAMID
	        Where 
		   tptid=6 and cd_Tp_cont in ('LCL','LCM') and TAMdtVal >= getdate() +3 
		Group by
		  Nome_tp_Tx, TX.cd_tp_moeda, txmValor,TXMEspec,org.Nome_local, 
		  dst.nome_local,TAMDtVal,dst.Pais_Local

	END




GO
