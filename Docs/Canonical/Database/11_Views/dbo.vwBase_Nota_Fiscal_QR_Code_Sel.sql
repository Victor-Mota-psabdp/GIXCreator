SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Base_Nota_Fiscal_QR_Code
CREATE VIEW [dbo].[vwBase_Nota_Fiscal_QR_Code_Sel]
AS
Select 
		QR.Id				[Code],				
		QR.Imagem			[Image],
		QR.QRcode_Url		[QRcode_Url],
		BNF.Nota_Fiscal		[Nota_Fiscal],
		BNF.Ref_Acesso		[Ref_Acesso],
		QR.Dt_Ins			[Insert Date],
		QR.Cd_Usuario		[User Code],
		US.nome_usuario		[User Name],
		QR.Status			[Enabled],
		BNF.RPS_NFE			[NFS-e Number],
		BNF.RPS_NFE_Verif	[Verification Code],
		BNF.RPS_Data		[Register Date]
	from Base_Nota_Fiscal BNF  	with(nolock)
	left join Base_Nota_Fiscal_QR_Code QR 	with(nolock) on BNF.Nota_Fiscal = QR.Nota_Fiscal and BNF.Ref_Acesso = QR.Ref_Acesso
	left join Usuario US 	with(nolock) on US.cd_usuario = QR.cd_usuario


GO
