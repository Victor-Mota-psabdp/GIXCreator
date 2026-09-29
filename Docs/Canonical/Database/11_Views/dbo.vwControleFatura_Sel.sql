SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from controle_fatura
--select * from controle_fatura_container
--select * from controle_fatura_protocolo
--select * from tipo_data_controle_fatura
--select * from tipo_cobranca_controle_fatura

CREATE view [dbo].[vwControleFatura_Sel] 

AS
	Select DISTINCT
		CF.cd_controlefatura	[01_Register Number],
		TC.nome_doc				[02_Invoice Type],					
		P.apelido			 	[03_Supplier],
		CF.num_fatura			[04_Invoice Number],
		dt_rcto_fatura			[05_Creation Date],
		dt_vcto_fatura			[06_Due Date],
		dt_envio_cliente		[07_Invoice Sent Date],
		valor					[08_Value],
		TM.nome_tp_moeda		[09_Currency],
		valor_brl				[10_Total Price]	
	From controle_fatura CF
		join tipo_moeda TM on TM.cd_tp_moeda = CF.cd_tp_moeda
		join pessoa P on P.cd_pes = CF.cd_fornecedor
		join tipo_Cobranca_Controle_Fatura TC on TC.id_dc = CF.cd_tipo
		left join controle_fatura_protocolo CFP on cfp.cd_protocolo = CF.cd_protocolo
		left join usuario U on U.cd_usuario = CFP.cd_usuario




























GO
