SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure	[dbo].[spAPAYExportTeste_Rel]

(
	@Processo varchar(16)
)

As

select 
	'1058637' Codigo,left(processo_pc,2)+left(right(processo_PC,9),7) Fatura,
	Num_CPF_CNPJ CNPJ,Num_Pedido,FAT.Processo_PC processo,Nome_Usuario Especialista,max(convert(char, Data_PC, 103)) Dt_Fatura,
	PD.num_pedido Pedido,PD.cd_pedido,cd_prod,Nota_Fiscal,SUM(VLR_TOTAL_ITEM) fob,num_po,num_pedido,GMID
from fatura_chb FAT with(nolock)
	Join Pessoa PP with(nolock) on PP.cd_pes=FAT.cd_pes_PC
	Join Pedido_Ship PS with(nolock) on PS.num_proc=processo_pc
	Join Pedido PD with(nolock) on PD.cd_pedido=PS.cd_pedido
	Join Produto_Cliente PC with(nolock) on PC.cd_prod=PS.cd_produto
	Join De_Para_Produto DP with(nolock) on DP.GMID=PC.cd_proc_cliente
	left join Usuario_Cliente US with(nolock) on US.cd_usuario=cd_CSRID
	LEFT Join Nota_cliente NC with(nolock) on NC.num_proc=Processo_PC
	left join nota_fiscal_cliente_det NCD with(nolock) on NC.ID_NF=NCD.ID_NF and NC.cd_cliente=NCD.cd_cliente and NCD.Cd_Produto=PS.cd_produto
where
	processo_pc = @Processo
Group by 
	left(processo_pc,2)+left(right(processo_PC,9),7) ,Num_CPF_CNPJ ,Num_Pedido,FAT.Processo_PC ,Nome_Usuario,
	PD.num_pedido,PD.cd_pedido,cd_prod,Nota_Fiscal,num_po,num_pedido,GMID

GO
