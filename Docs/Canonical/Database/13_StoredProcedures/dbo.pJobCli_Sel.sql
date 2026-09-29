SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pJobCli_Sel 
(
@Apelido		VarChar(20)='%',
@Modal		VarChar(2) 
)
AS
	If @Apelido = ''
		Set @Apelido = '%'
	If @Modal = 'IA'
		Begin 
			Select 
				HIA.Num_Proc_HIA Job,
				Origem.Nome_Local Origem, 
				Destino.Nome_Local Destino,	
				Cliente.Apelido Cliente, 
				Voo_HIA Voo, 
				Peso_Real_HIA Peso, 
				Obs_HIA Obs 
			From 
				House_Imp_Aer HIA Join Localidade Origem on Origem.Cd_Local = HIA.Cd_Org_HIA 
				Join Localidade Destino on Destino.Cd_Local = HIA.Cd_Dst_HIA 
				Join Pessoa Cliente on Cliente.Cd_Pes = HIA.Cd_Import_HIA 
			Where
				HIA.Num_Proc_HIA like 'IAJOB%' and 
				Cliente.Apelido = @Apelido
		End 

	If @Modal = 'EA'
		Begin 
			Select 
				HEA.Num_Proc_HEA Job,
				Origem.Nome_Local Origem, 
				Destino.Nome_Local Destino,	
				Cliente.Apelido Cliente, 
				Voo_HEA Voo, 
				Peso_Real_HEA Peso, 
				Obs_HEA Obs 
			From 
				House_Exp_Aer HEA Join Localidade Origem on Origem.Cd_Local = HEA.Cd_Org_HEA 
				Join Localidade Destino on Destino.Cd_Local = HEA.Cd_Dst_HEA 
				Join Pessoa Cliente on Cliente.Cd_Pes = HEA.Cd_Export_HEA 
			Where
				HEA.Num_Proc_HEA like 'EAJOB%' and 
				Cliente.Apelido = @Apelido
		End 

	If @Modal = 'IM'
		Begin 
			Select 
				HIM.Num_Proc_HIM Job,
				Origem.Nome_Local Origem, 
				Destino.Nome_Local Destino,	
				Cliente.Apelido Cliente, 
				Navio_HIM Navio,
				Peso_Bruto_HIM Peso_Bruto, 
				Peso_Liquido_HIM Peso_Liq, 
				Obs_HIM Obs 
			From 
				House_Imp_Mar HIM Join Localidade Origem on Origem.Cd_Local = HIm.Cd_Org_HIM
				Join Localidade Destino on Destino.Cd_Local = HIM.Cd_Dst_HIM 
				Join Pessoa Cliente on Cliente.Cd_Pes = HIM.Cd_Import_HIM
			Where
				HIM.Num_Proc_HIM like 'IMJOB%' and 
				Cliente.Apelido = @Apelido
		End 


	If @Modal = 'EM'
		Begin 
			Select 
				HEM.Num_Proc_HEM Job,
				Origem.Nome_Local Origem, 
				Destino.Nome_Local Destino,	
				Cliente.Apelido Cliente, 
				Navio_HEM Navio,
				Peso_Bruto_HEM Peso_Bruto, 
				Peso_Liquido_HEM Peso_Liq, 
				Obs_HEM Obs 
			From 
				House_Exp_Mar HEM Join Localidade Origem on Origem.Cd_Local = HEM.Cd_Org_HEM
				Join Localidade Destino on Destino.Cd_Local = HEM.Cd_Dst_HEM 
				Join Pessoa Cliente on Cliente.Cd_Pes = HEM.Cd_Export_HEM

			Where
				HEM.Num_Proc_HEM like 'EMJOB%' and 
				Cliente.Apelido = @Apelido
		End
GO
