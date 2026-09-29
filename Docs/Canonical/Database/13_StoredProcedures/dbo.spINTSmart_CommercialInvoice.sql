SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from invoice_cliente where Id_inv >= '10545'

--[spINTSmart_CommercialInvoice] 'EMCSR201908037BR'
--select * from Tipo_Campo_Cliente where id_campo = '87' 
--select * from vwHouse_Imp where num_proc in ('IAATL202404001BR','IMATL202404001BR','IOATL202404001BR')
--select * from Campo_Processo where num_proc in ('IAATL202404001BR','IMATL202404001BR','IOATL202404001BR')

CREATE PROCEDURE [dbo].[spINTSmart_CommercialInvoice]
(
	@num_proc	varchar(16)
)
as
	select  
		--Isnull(TP.Cd_Termo,'281') Cd_Termo,
		--Isnull(Descricao_Termo,'60 Days of Invoice Date') Termo,
		TP.cd_termo Cd_Termo,
		TP.Descricao_Termo Termo,
		HOU.Vlr_Invoice,
		Moeda_invoice Cd_Tp_moeda					
	from 
		vwHouse_Imp HOU WITH(nolock)
		Left Join Campo_Processo CP on CP.Num_proc = HOU.Num_Proc and CP.Id_Campo = 87
		Left join Termo_Pagamento TP on cast(TP.cd_termo as varchar(30)) = CP.Campo_Dados
	WHERE
		HOU.NUM_PROC=@num_proc

	UNION ALL

	select  
		--Isnull(TP.Cd_Termo,'281') Cd_Termo,
		--Isnull(Descricao_Termo,'60 Days of Invoice Date') Termo,
		TP.cd_termo Cd_Termo,
		TP.Descricao_Termo Termo,
		HOU.Vlr_Invoice,
		Moeda_invoice Cd_Tp_moeda					
	from 
		vwHouse_Exp HOU WITH(nolock)
		Left Join Campo_Processo CP on CP.Num_proc = HOU.Num_Proc and CP.Id_Campo = 87
		Left join Termo_Pagamento TP on cast(TP.cd_termo as varchar(30)) = CP.Campo_Dados
	WHERE
		HOU.NUM_PROC=@num_proc
GO
