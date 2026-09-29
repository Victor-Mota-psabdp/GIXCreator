SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spVerificaDataNF_MesAnterior]--'IMATL201306181BRB'
	@Nota_fiscal varchar(10),
	@Ref_Acesso char(1)	
as
select  
	NF.emissao,NF.nota_fiscal,GETDATE() ServerDate 	
from 
	base_nota_fiscal NF
where
	nf.notA_fiscal = @Nota_fiscal
	and ref_acesso = @Ref_Acesso
	

    
GO
