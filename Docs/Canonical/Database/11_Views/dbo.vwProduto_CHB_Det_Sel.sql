SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Produto_CHB_Det
CREATE VIEW [dbo].[vwProduto_CHB_Det_Sel]
AS
	select 
			convert(varchar(10),'Saved')		[Status],
			PD.cd_prod							[Code],
			PC.cd_Proc_Cliente					[Product Code],
			PC.Produto_Descr					[Product Description],
			PC.cd_Cliente						[Group Code], 
			G.apelido							[Group Name],
			PD.Cd_Tp_Tx							[Charge Code],
			TP.Nome_Tp_Tx						[Charge Name],
			CONVERT(DECIMAL(18,2),Porcentagem)	[Percentage]
		from Produto_CHB_Det PD with(nolock)
			join Produto_Cliente PC on PC.cd_prod = PD.cd_prod
			join Pessoa G with(nolock) on G.Cd_Pes = PC.cd_Cliente
			LEFT join Tipo_Taxa TP with(nolock) on TP.cd_tp_tx=PD.cd_tp_tx	



GO
