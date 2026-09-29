SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spLERXML_Verifica_NFCalculos_Sel](
	@Num_Proc as varchar(16)
)
as

select * from nota_fiscal_cliente_det ND
     Join Nota_Cliente NC on NC.id_nf=ND.id_NF and nc.cd_cliente=nd.cd_cliente
     Where num_proc=@Num_Proc and substring(num_proc,3,3) not in ('LVS','SLA')
	

GO
