SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pHIM_SVia_Sel 
(
@Num_Proc	VarChar(16) 
)
AS
	Select 
		Vg.Nr_Viagem,  Vg.Ano_Viagem, HAWB_HIM, Emiss.BITRI as Porto_Emissao, Arm.Cd_Arm_Ofc, HIM.Dt_Emis_HIM, 
		HIM.Obs_HIM, Shipper.Nome_Raz_Soc as Shipper, Consig.Nome_Raz_Soc as Consignee, 
		Notify.Nome_Raz_Soc as Notify, Transbordo.BITRI as Porto_Transb, Destino.BITRI as Porto_Destino, 
		Transito_HIM, Cd_Emissor, MIM.MAWB_MIM, Destino_MIM.BITRI as Porto_Destino_MIM, Term.Cd_Repart,  Term.Cd_Term_Ofc, 
		Emiss_MIM.BITRI as Porto_Emissao_MIM, Dt_Emis_MIM
	From 	
		House_Imp_Mar as HIM Left Outer Join Viagem as Vg on HIM.ID_Viagem = Vg.ID_Viagem 
		Join Master_Imp_Mar as MIM on HIM.Num_Proc_MIM = MIM.Num_Proc_MIM 
		Left Outer Join Terminal as Term on MIM.Cd_Terminal = Term.Cd_Terminal
		Left Outer Join Armador as Arm on MIM.Cd_Armador = Arm.Cd_Armador
		Left Outer Join Localidade as Emiss on HIM.Cd_Org_HIM = Emiss.Cd_Local
		Left Outer Join Localidade as Destino on HIM.Cd_Dst_HIM = Destino.Cd_Local
		Left Outer Join Localidade as Destino_MIM on MIM.Cd_Dst_MIM = Destino_MIM.Cd_Local
		Left Outer Join Localidade as Emiss_MIM on MIM.Cd_Org_MIM = Emiss_MIM.Cd_Local
		Left Outer Join Pessoa as Shipper on HIM.Cd_Export_HIM = Shipper.Cd_Pes 
		Left Outer Join Pessoa as Notify on HIM.Cd_Import_HIM = Notify.Cd_Pes 
		Left Outer Join Pessoa as Consig on HIM.Cd_Consig_HIM = Consig.Cd_Pes 
		Left Outer Join Localidade as Transbordo on MIM.Cd_Transb_MIM = Transbordo.Cd_Local
	Where 
		Num_Proc_HIM= @Num_Proc



GO
