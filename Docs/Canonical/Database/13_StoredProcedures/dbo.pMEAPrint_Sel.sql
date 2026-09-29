SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE     PROCEDURE [dbo].[pMEAPrint_Sel] --EAPOA200906001
(
@Num_Proc	Varchar(16)
)
AS
Declare @StrHouse	VarChar(20)
Declare @StrHouses	VarChar(400)
Declare @Paridade	Float
Declare @TotCarrier	Float 

Set @TotCarrier = IsNull((Select Sum(Vlr_Org_MEA) From Cta_Cte_Mas_Exp_Aer as Cte Join Master_Exp_Aer as MEA on MEA.Num_Proc_MEA = Cte.Num_Proc_MEA 
			Where Cte.Num_Proc_MEA =@Num_Proc and Cte.Cd_Tp_Moeda = MEA.Cd_Tp_Moeda and Comp_MBL_MEA = 'S'),0)
Set @StrHouses = '' 
Declare CurHouse Cursor For 
	Select HAWB_HEA From House_Exp_Aer Where Num_Proc_MEA = @Num_Proc 

Open CurHouse 
Fetch Next From CurHouse into @StrHouse 
While @@Fetch_Status = 0
	Begin 
		If @StrHouses <> ''  
			Set @StrHouses = @StrHouses + ', ' + @StrHouse 
		Else
			Set @StrHouses = 'HAWB: ' + @StrHouse 
		Fetch Next From CurHouse into @StrHouse 
	End 
Close CurHouse
Deallocate CurHouse

Select 
	MEA.MAWB_MEA, Cd_Org_MEA, Cd_Dst_MEA, destino.nome_local as Destino_Local, Cd_Gat_MEA, Origem.Nome_Local as Origem, Destino.Nome_Local as Destino, 
	Shipper.Nome_Raz_Soc as Shipper, Shipper.Num_CPF_CNPJ as Shipper_CNPJ, 
	End_Shipper.Rua as Shipper_Rua, End_Shipper.Numero as Shipper_Nr, End_Shipper.Compl_End as Shipper_Compl, 
	End_Shipper.CEP as Shipper_CEP, End_Shipper.Bairro as Shipper_Bairro, End_Shipper.Cidade as Shipper_Cid, 
	End_Shipper.UF as Shipper_UF, End_Shipper.Pais as Shipper_Pais,

	Consignee.Nome_Raz_Soc as Consignee, 
	End_Consignee.Rua as Consignee_Rua, End_Consignee.Numero as Consignee_Nr, End_Consignee.Compl_End as Consignee_Compl, 
	End_Consignee.CEP as Consignee_CEP, End_Consignee.Bairro as Consignee_Bairro, End_Consignee.Cidade as Consignee_Cid, 
	End_Consignee.UF as Consignee_UF, End_Consignee.Pais as Consignee_Pais, Consignee.Obs_Pes Consignee_Obs,

	Cia.Nome_Cia_Aer, 
	Tipo_Frete = 
	Case 
		When MEA.Tp_Frete_MEA = 'P' then 'FREIGHT PREPAID'
		Else 'FREIGHT COLLECT' 
	End, 

	Cd_Tp_Moeda as Moeda, @StrHouses as Houses, Tx_Refer_MEA as Paridade, Voo_MEA as Voo, Dt_Saida_MEA as Saida,
	Hand.Hand_MEA_1, Hand.Hand_MEA_2, Hand.Hand_MEA_3, MEA.Trf_Net_MEA, MEA.Qtd_Tot_Vol_MEA, 
	MEA.Peso_Bruto_MEA, MEA.Qtd_Tot_Vol_MEA, Vlr_Frete_MEA, @TotCarrier as TotCarrier, MEA.Peso_Tax_MEA, 

	Com_Ship.Contato Contato_Ship, Com_Ship.Cd_Area_Fone  Cd_Area_Fone_Ship, Com_Ship.Prefixo Prefixo_Ship, 
	Com_Ship.Num_Fone Num_Fone_Ship, Obs_Mea,

	Com_Cons.Contato Contato_Cons, Com_Cons.Cd_Area_Fone  Cd_Area_Fone_Cons, Com_Cons.Prefixo Prefixo_Cons, 
	Com_Cons.Num_Fone Num_Fone_Cons , Refer_Cons_MEA, MEA.Dt_Impres_MEA, MEA.Consig_Acc_MEA,PRD.Prod_MEA

From 
	Master_Exp_Aer as MEA Left Outer Join Pessoa as Shipper on Shipper.Cd_Pes = MEA.Cd_Export_MEA
	Left Outer Join Endereco as End_Shipper on End_Shipper.Cd_Pes = Shipper.Cd_Pes and End_Shipper.Cd_Tp_End = 'COM'
	Left OUter Join Comunicacao Com_Ship on Com_Ship.Cd_Pes = MEA.Cd_Export_MEA and Com_Ship.Cd_Tp_Com = 'HBL'

	Left Outer Join Pessoa as Consignee on Consignee.Cd_Pes = MEA.Cd_Consig_MEA
	Left Outer Join Endereco as End_Consignee on End_Consignee.Cd_Pes = Consignee.Cd_Pes and End_Consignee.Cd_Tp_End = 'COM'
	Left OUter Join Comunicacao Com_Cons on Com_Cons.Cd_Pes = MEA.Cd_Consig_MEA and Com_Cons.Cd_Tp_Com = 'HBL'

	Left Outer Join Cia_Aerea as Cia on Cia.Cd_Cia_Aer = MEA.Cd_Cia_Aer 

	Left Outer Join Localidade as Origem on Origem.Cd_Local = MEA.Cd_Org_MEA
	Left Outer Join Localidade as Destino on Destino.Cd_Local = MEA.Cd_Dst_MEA
	Left Outer Join Localidade as GateWay on GateWay.Cd_Local = MEA.Cd_Gat_MEA
	Left Outer Join Handling_MEA as Hand on Hand.Num_Proc_MEA = MEA.Num_Proc_MEA
	Left Outer Join Prd_mas_exp_aer as PRD on MEA.num_proc_mea=PRD.num_proc_mea
where 
	MEA.Num_Proc_MEA = @Num_Proc




GO
