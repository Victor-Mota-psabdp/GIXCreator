SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================
-- Author:		Claudio Alves
-- Create date: 13/05/2009
-- Description:	Select para gerar planilha "Draft da NF por Processo"
-- no módulo GeraXLS-GRP
-- ========================================================================
CREATE PROCEDURE [dbo].[spDraftNF_Rel] --'IMMPC20090200801'
(
	@Processo varchar(16)
)
AS
BEGIN

	SET NOCOUNT ON;

	select
		isnull(HIM.HAWB_HIM,isnull(HIA.HAWB_HIA,HIO.HAWB_HIO)) House,
		dbo.fBusca_Docs_PO_Modal(@Processo,5) DI,
		dbo.fBusca_Docs_PO_Modal(@Processo,1) PO,
		dbo.fBusca_CampoCliente(@Processo,25) Desembaraco,
		dbo.fBusca_PRODUTO(@Processo)		  Produto,
		CFOP, 
		Paridade,
		Nota_Fiscal,
		ID_NF,
		Cd_Cliente
	from 
		Nota_Cliente NC with(nolock)
		Left Join House_Imp_Mar HIM with(nolock) on HIM.Num_Proc_HIM=NC.Num_Proc
		Left Join House_Imp_Aer HIA with(nolock) on HIA.Num_Proc_HIA=NC.Num_Proc
		Left Join House_Imp_Out HIO with(nolock) on HIO.Num_Proc_HIO=NC.Num_Proc
	where 
		Num_Proc=@Processo

END

GO
