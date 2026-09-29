SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pHBL_Sel  
(
@Processo		VarChar(16) 
)
AS
	If Exists(Select Num_Proc From HBL Where Num_Proc = @Processo)
		Begin 
			Select 
				1 as Cadastrado, *  
			From 
				HBL
			Where 
				Num_Proc = @Processo
		End 
	Else
		Begin 
			Select 0 as Cadastrado, 
				HEM.*, 
				Shipper.Nome_Raz_Soc Shipper, Ship_End.Rua Ship_Rua,  Ship_End.Numero Ship_Numero, Ship_End.Compl_End Ship_Compl, Ship_End.CEP Ship_CEP, 
				Ship_End.Bairro Ship_Bairro, Ship_End.Cidade Ship_Cidade, Ship_End.UF Ship_UF, Ship_End.Pais Ship_Pais,  Ship_Com.Contato Ship_Contato, 
				Ship_Com.Cd_Int Ship_Cd_Int, Ship_Com.Cd_Area_Fone Ship_Cd_Area_Fone, Ship_Com.Prefixo Ship_Prefixo, Ship_Com.Num_Fone Ship_Num_Fone, 

				Consig.Nome_Raz_Soc Consig, Consig_End.Rua Consig_Rua,  Consig_End.Numero Consig_Numero, Consig_End.Compl_End Consig_Compl, Consig_End.CEP Consig_CEP, 
				Consig_End.Bairro Consig_Bairro, Consig_End.Cidade Consig_Cidade, Consig_End.UF Consig_UF, Consig_End.Pais Consig_Pais,   Consig_Com.Contato Consig_Contato, 
				Consig_Com.Cd_Int Consig_Cd_Int, Consig_Com.Cd_Area_Fone Consig_Cd_Area_Fone, Consig_Com.Prefixo Consig_Prefixo, Consig_Com.Num_Fone Consig_Num_Fone, 

				Notify.Nome_Raz_Soc Notify, Notify_End.Rua Notify_Rua,  Notify_End.Numero Notify_Numero, Notify_End.Compl_End Notify_Compl, Notify_End.CEP Notify_CEP, 
				Notify_End.Bairro Notify_Bairro, Notify_End.Cidade Notify_Cidade, Notify_End.UF Notify_UF, Notify_End.Pais Notify_Pais,  Notify_Com.Contato Notify_Contato, 
				Notify_Com.Cd_Int Notify_Cd_Int, Notify_Com.Cd_Area_Fone Notify_Cd_Area_Fone, Notify_Com.Prefixo Notify_Prefixo, Notify_Com.Num_Fone Notify_Num_Fone,	
				Origem.Nome_Local Origem, Destino.Nome_Local Destino , TE.*

			From 
				House_Exp_Mar	HEM 
				Join Pessoa Shipper on Shipper.Cd_Pes = HEM.Cd_Export_HEM 
				Left Join Endereco Ship_End on Ship_End.Cd_Pes = Shipper.Cd_Pes and Ship_End.Cd_Tp_End = 'COM'
				Left Join Comunicacao Ship_Com on Ship_Com.Cd_Pes = Shipper.Cd_Pes and Ship_Com.Cd_Tp_Com = 'TC1'

				Join Pessoa Consig on Consig.Cd_Pes = HEM.Cd_Consig_HEM 
				Left Join Endereco Consig_End on Consig_End.Cd_Pes = Consig.Cd_Pes and Consig_End.Cd_Tp_End = 'COM'
				Left Join Comunicacao Consig_Com on Ship_Com.Cd_Pes = Consig.Cd_Pes and Consig_Com.Cd_Tp_Com = 'TC1'

				Join Pessoa Notify on Notify.Cd_Pes = HEM.Cd_Notify_HEM
				Left Join Endereco Notify_End on Notify_End.Cd_Pes = Notify.Cd_Pes and Notify_End.Cd_Tp_End = 'COM'
				Left Join Comunicacao Notify_Com on Notify_Com.Cd_Pes = Notify.Cd_Pes and Notify_Com.Cd_Tp_Com = 'TC1'

				Join Localidade Origem on Origem.Cd_Local = HEM.Cd_Org_HEM 
				Join Localidade Destino on Destino.Cd_Local = HEM.Cd_Dst_HEM 

				Join Tipo_Embalagem TE on TE.Cd_Tp_Embal = HEM.Cd_Tp_Embal

			Where
				HEM.Num_Proc_HEM = @Processo
		End

GO
