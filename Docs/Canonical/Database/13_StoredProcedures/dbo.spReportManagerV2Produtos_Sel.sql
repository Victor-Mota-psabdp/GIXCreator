SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--spReportManagerV2Produtos_Sel 'IMATL201402051BR' - N/A
--spReportManagerV2Produtos_Sel 'IAGVD201611004BR' - PROD
--spReportManagerV2Produtos_Sel 'EMCSR201709093BR' - NULL
CREATE Procedure [dbo].[spReportManagerV2Produtos_Sel]
		@Num_Proc	Varchar(16)

AS
If exists(Select cd_produto from Pedido_Ship where num_proc = @Num_Proc)
	Begin
		select Distinct Cd_Proc_Cliente Produto from Pedido_Ship with(nolock)
		Join Produto_Cliente PC with(nolock) on cd_produto=cd_prod
		Where Num_Proc=@Num_Proc
	End
else
	Begin
		select TOP 1'N/A' Produto from proc_ncm P with(nolock)
		Join NCM with(nolock) on NCM.id_ncm=P.ID_Ncm
		Join vwHouse_Exp hou with(nolock) on hou.num_proc=P.num_proc
		where
			P.num_proc=@Num_Proc
		union 
		select TOP 1'N/A' Produto from proc_ncm P with(nolock)
		Join NCM with(nolock) on NCM.id_ncm=P.ID_Ncm
		Join vwHouse_IMP hou with(nolock) on hou.num_proc=P.num_proc
		where
			P.num_proc=@Num_Proc
	End
GO
