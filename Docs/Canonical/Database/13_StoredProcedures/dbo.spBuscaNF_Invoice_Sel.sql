SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBuscaNF_Invoice_Sel]--47710,'A'
	@Nota_fiscal Varchar(10),
	@Ref_Acesso		char(1)	
as
	select 
		Numero_Fat,Emissao ,Nome_Usuario
	from nf_fatura  NF
	join Usuario U on U.Cd_Usuario = NF.cd_usuario
	where
		nf.nota_fiscal = @Nota_fiscal
		and ref_acesso =  @Ref_Acesso		


GO
