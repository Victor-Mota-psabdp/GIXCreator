SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pHEM_SVia_Sel 
(
@Num_Proc	VarChar(16) 
)
AS
	Select 
		Vg.Nr_Viagem,  Vg.Ano_Viagem, HAWB_HEM, Emiss.BITRI as Porto_Emissao, Arm.Cd_Arm_Ofc, HEM.Dt_Emis_HEM, 
		HEM.Obs_HEM, Shipper.Nome_Raz_Soc as Shipper, Consig.Nome_Raz_Soc as Conisgnee, 
		Notify.Nome_Raz_Soc as Notify,  Destino.BITRI as Porto_Destino, 
		Transito_HEM,  Cd_Emissor, MEM.MAWB_MEM, Destino_MEM.BITRI as Porto_Destino_MEM, 
		Term.Nome_Terminal, Term.Cd_Repart, Term.Cd_Term_Ofc, Emiss_MEM.BITRI as Porto_Emissao_MEM, 
		Dt_Emis_MEM
	From 
		House_Exp_Mar as HEM Left Outer Join Viagem as Vg on HEM.ID_Viagem = Vg.ID_Viagem 
		Join Master_Exp_Mar as MEM on HEM.Num_Proc_MEM = MEM.Num_Proc_MEM 
		Left Outer Join Terminal as Term on MEM.Cd_Terminal = Term.Cd_Terminal 
		Left Outer Join Armador as Arm on MEM.Cd_Armador = Arm.Cd_Armador
		Left Outer Join Localidade as Emiss on HEM.Cd_Org_HEM = Emiss.Cd_Local
		Left Outer Join Localidade as Destino on HEM.Cd_Dst_HEM = Destino.Cd_Local
		Left Outer Join Localidade as Destino_MEM on MEM.Cd_Dst_MEM = Destino_MEM.Cd_Local
		Left Outer Join Localidade as Emiss_MEM on HEM.Cd_Org_HEM = Emiss_MEM.Cd_Local
		Left Outer Join Pessoa as Shipper on HEM.Cd_Export_HEM = Shipper.Cd_Pes 
		Left Outer Join Pessoa as Notify on HEM.Cd_Notify_HEM = Notify.Cd_Pes 
		Left Outer Join Pessoa as Consig on HEM.Cd_Consig_HEM = Consig.Cd_Pes 
	Where 
		Num_Proc_HEM= @Num_Proc



GO
