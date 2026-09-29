SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pJobExp_Rel
(
@Num_Proc 		VarChar(16)
)
AS
	IF Left(@Num_Proc, 2) = 'EA'  
		Begin 
			Select 
				HEA.*, Consig.Nome_Raz_Soc as Consignatario, Shipper.Nome_Raz_Soc as Shipper, 
				Notify.Nome_Raz_Soc as Notify, Origem.Nome_Local as Origem, 
				Destino.Nome_Local as Destino, Cia.Nome_Cia_Aer as Cia_Aerea,
				Desp.Apelido as Despachante, Agente.Nome_Raz_Soc as Agente, 
				HEA.Peso_Real_HEA as Peso_Cubado, TE.Nome_Tp_Embal as Embalagem, 
				JEA.Inv_HEA as Invoice, JEA.MAWB_HEA as Master
				
			From 
				House_Exp_Aer as HEA Join Job_Exp_Aer as JEA on JEA.Num_Proc_HEA = HEA.Num_Proc_HEA
				Left Outer Join Pessoa as Agente on Agente.Cd_Pes = JEA.Cd_Agente 
				Join Pessoa as Consig on Consig.Cd_Pes = HEA.Cd_Consig_HEA
				Join Pessoa as Shipper on Shipper.Cd_Pes = HEA.Cd_Export_HEA
				Join Pessoa as Notify on Notify.Cd_Pes = HEA.Cd_Notify_HEA
				Join Pessoa as Desp on Desp.Cd_Pes = HEA.Cd_Dsp_HEA
				Join Cia_Aerea as Cia on Cia.Cd_Cia_Aer = HEA.Cd_Cia_Aer  
				Join Localidade as Origem on HEA.Cd_Org_HEA = Origem.Cd_Local 
				Join Localidade as Destino on HEA.Cd_Dst_HEA = Destino.Cd_Local 
				Left Outer Join Tipo_Embalagem as TE on TE.Cd_Tp_Embal = JEA.Cd_Tp_Embal 
			Where 
				HEA.Num_Proc_HEA = @Num_Proc 

		End
	Else
		Begin 
			If Left(@Num_Proc, 2) = 'EM'  
				Begin 
					Select 
						*, Consig.Nome_Raz_Soc as Consignatario, Shipper.Nome_Raz_Soc as Shipper, 
						Notify.Nome_Raz_Soc as Notify, Origem.Nome_Local as Origem, 
						Destino.Nome_Local as Destino, Desp.Apelido as Despachante  
					From 
						House_Exp_Mar as HEM Join Pessoa as Consig on Consig.Cd_Pes = HEM.Cd_Consig_HEM
						Join Pessoa as Shipper on Shipper.Cd_Pes = HEM.Cd_Export_HEM
						Join Pessoa as Notify on Notify.Cd_Pes = HEM.Cd_Notify_HEM
						Join Pessoa as Desp on Desp.Cd_Pes = HEM.Cd_Dsp_HEM
						Join Localidade as Origem on HEM.Cd_Org_HEM = Origem.Cd_Local 
						Join Localidade as Destino on HEM.Cd_Dst_HEM = Destino.Cd_Local 
					Where 
						Num_Proc_HEM = @Num_Proc 
				End 
		End

GO
