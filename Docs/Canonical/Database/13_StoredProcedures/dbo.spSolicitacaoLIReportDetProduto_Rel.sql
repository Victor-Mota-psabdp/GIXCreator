SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spSolicitacaoLIReportDetProduto_Rel] --'IMCSR20110116001'
	@Num_Proc	VArchar(16)
AS

declare @cd_pes_grupo varchar(10)
set @cd_pes_grupo = (select cd_pes_grupo from grupo where grupo = substring(@num_proc,3,3))

select 
	cd_proc_cliente CodProduto,
	Produto_Descr,
	P.Num_Pedido,
	Value_Center_Descr,
	Business_Group_Descr,
	NCM 
from solicitacao_li_produto SLI
Join Solicitacao_LI SL on SL.num_solicitacao=SLI.num_solicitacao
Join Produto_Cliente PC on PC.cd_prod=SLI.cd_produto and PC.cd_cliente = @cd_pes_grupo
Left Join De_PAra_PRoduto DPP on DPP.GMID=PC.cd_proc_cliente
Left Join NCM on SLI.id_NCM=NCM.id_NCM
left join Pedido_Ship PS on SL.Num_Proc = PS.Num_Proc
left join Pedido P on PS.cd_pedido = P.Cd_Pedido
where
	SL.Num_Proc=@num_proc
Group by 
	cd_proc_cliente ,Produto_Descr,P.Num_Pedido,Value_Center_Descr,Business_Group_Descr,NCM

select * from Produto_Cliente


GO
