SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spReqCabecalho_Sel] --'249/08'

	@Requerimento varchar(15)

as

	select 
		ID_Req,
		Numero_Requerimento,
		Apelido Consig_Req,
		UoM_Req,
		Quant_Req,
		Dt_Req,
		Dt_Vencimento_Req,
		PC.cd_Proc_Cliente,
		PC.Produto_Descr
	from 
		Requerimento RQ
	left outer join Pessoa CSN on RQ.cd_consig_Req=CSN.cd_pes
	left outer join Produto_Cliente PC on RQ.Id_Produto=PC.Cd_Prod and cd_cliente = 1
	where 
		Numero_Requerimento = @Requerimento






GO
