SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure spPessoaNovos_Rel
		(
			@DataInicial Char(10),
			@DataFinal   Char(10)
		)

AS

Select Apelido, Nome_Raz_Soc, Cidade, UF from Pessoa PP
Left Join House_imp_mar HIM on HIM.cd_import_him=pp.cd_pes
Left Join House_imp_aer HIA on HIA.cd_import_hia=pp.cd_pes
Left Join Endereco ED on PP.cd_pes=ED.cd_pes
Where 
	convert(Datetime,dt_cad,105) between @DataInicial and @DataFinal
	and (HIM.num_proc_him is not null and HIA.num_proc_hia is not null)
Group by
	Apelido, Nome_Raz_Soc, Cidade, UF 




GO
