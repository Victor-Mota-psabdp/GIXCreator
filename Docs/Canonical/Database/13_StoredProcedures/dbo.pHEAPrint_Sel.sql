SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE   PROCEDURE [dbo].[pHEAPrint_Sel]
(
@Num_Proc	Varchar(16)
)
AS
Declare @StrHouse	VarChar(20)
Declare @StrHouses	VarChar(400)
Declare @Paridade	Float
Declare @TotCarrier	Float 
Declare @TotAgent	Float 

Set @TotCarrier = IsNull((Select Sum(Vlr_Org_HEA) From Cta_Cte_Hou_Exp_Aer as Cte Join House_Exp_Aer as HEA on HEA.Num_Proc_HEA = Cte.Num_Proc_HEA 
			Where Cte.Num_Proc_HEA =@Num_Proc and Cte.Cd_Tp_Moeda = HEA.Cd_Tp_Moeda and Comp_HAWB_HEA = 'S'  and DC_HEA = 'C' and Cd_Tp_Tx in 
			(Select Cd_Tp_Tx From Cta_Cte_mAS_Exp_Aer  Where Num_Proc_MEA = Left(@Num_Proc, 14) and DC_MEA = 'D')),0)

Set @TotAgent = IsNull((Select Sum(Vlr_Org_HEA) From Cta_Cte_Hou_Exp_Aer as Cte Join House_Exp_Aer as HEA on HEA.Num_Proc_HEA = Cte.Num_Proc_HEA 
			Where Cte.Num_Proc_HEA =@Num_Proc and Cte.Cd_Tp_Moeda = HEA.Cd_Tp_Moeda and Comp_HAWB_HEA = 'S'  and DC_HEA = 'C' and  Cd_Tp_Tx not in 
			(Select Cd_Tp_Tx From Cta_Cte_Mas_Exp_Aer  Where Num_Proc_MEA = Left(@Num_Proc, 14) and DC_MEA = 'D')),0)

Set @StrHouses = '' 

Declare CurHouse Cursor For 
	Select HAWB_HEA From House_Exp_Aer Where Num_Proc_HEA = @Num_Proc 

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
	HEA.Num_proc_HEA,  HEA.HAWB_HEA, Cd_Org_MEA, Cd_Dst_MEA, Cd_Gat_MEA, 
	Origem.Nome_Local as Origem, Destino.Nome_Local as Destino, Gateway.Nome_Local as Gateway, 
	Shipper.Nome_Raz_Soc as Shipper, Shipper.Num_CPF_CNPJ as Shipper_CNPJ, 
	End_Shipper.Rua as Shipper_Rua,Consignee.Obs_pes,End_Shipper.Numero as Shipper_Nr, End_Shipper.Compl_End as Shipper_Compl, 
	End_Shipper.CEP as Shipper_CEP, End_Shipper.Bairro as Shipper_Bairro, End_Shipper.Cidade as Shipper_Cid, 
	End_Shipper.UF as Shipper_UF, End_Shipper.Pais as Shipper_Pais, Consignee.Nome_Raz_Soc as Consignee, 
	End_Consignee.Rua as Consignee_Rua, End_Consignee.Numero as Consignee_Nr, End_Consignee.Compl_End as Consignee_Compl, 
	End_Consignee.CEP as Consignee_CEP, End_Consignee.Bairro as Consignee_Bairro, End_Consignee.Cidade as Consignee_Cid, 
	End_Consignee.UF as Consignee_UF, End_Consignee.Pais as Consignee_Pais,
	Cia.Nome_Cia_Aer, 
	Tipo_Frete = 
	Case 
		When HEA.Tp_Frete_HEA = 'P' then 'FREIGHT PREPAID'
		Else 'FREIGHT COLLECT' 
	End, 
	HEA.Cd_Tp_Moeda as Moeda, Tx_Refer_HEA as Paridade, Voo_HEA as Voo, ETA_HEA as Saida,
	HEA.Trf_Vd_HEA, HEA.Qtd_Tot_Vol_HEA, 
	HEA.Peso_Real_HEA, HEA.Qtd_Tot_Vol_HEA, Vlr_Frete_Tot_HEA, @TotCarrier as TotCarrier, 
	Qtd_Vol_EA, Compr_EA, Largura_EA, Altura_EA, Cd_Tp_Unidade, Vol_Item_EA, @TotAgent as TotAgent, 
	Prod_HEA as Produto, Numero_PO_HEA, Hand_HEA_1, Hand_HEA_2, Hand_HEA_3, 
	HEA.Peso_Bruto_HEA, HAWB_Instruct, MEA.MAWB_MEA, Peso_Tax, MEA.Cd_Org_MEA as Org_MEA, 
	Com_Ship.Contato Contato_Ship, Com_Ship.Cd_Area_Fone  Cd_Area_Fone_Ship, Com_Ship.Prefixo Prefixo_Ship, 
	Com_Ship.Num_Fone Num_Fone_Ship, (Com_Consig.Cd_Int + ' ' + Com_Consig.cd_area_fone + ' ' + Com_Consig.Prefixo + ' - ' + Com_Consig.Num_Fone + ' ' + Isnull(Com_Consig.Compl_Fone,'')) as Contato_Consignee,MEA.Dt_Impres_MEA, Convert(Datetime, Dt_Rcb_Doc_HEA, 105)  Dt_Rcb_Doc_HEA
--+ ' ' + Com_Consig.cd_area_fone + ' ' + Com_Consig.Prefixo+'-'+Com_Consig.Num_Fone + ' ' + Com_Consig.Compl_Fone
From 
	House_Exp_Aer as HEA Join Master_Exp_Aer as MEA on MEA.Num_Proc_MEA = HEA.Num_Proc_MEA
	Left Outer Join Pessoa as Shipper on Shipper.Cd_Pes = HEA.Cd_Export_HEA
	Left Outer Join Endereco as End_Shipper on End_Shipper.Cd_Pes = Shipper.Cd_Pes and End_Shipper.Cd_Tp_End = 'COM'
	Left Outer Join Comunicacao Com_Ship on Com_Ship.Cd_Pes = HEA.Cd_Export_HEA and Com_Ship.Cd_Tp_Com = 'HBL'
	Left Outer Join Pessoa as Consignee on Consignee.Cd_Pes = HEA.Cd_Consig_HEA
	Left Outer Join Endereco as End_Consignee on End_Consignee.Cd_Pes = Consignee.Cd_Pes and End_Consignee.Cd_Tp_End = 'COM'
	Left Outer Join Cia_Aerea as Cia on Cia.Cd_Cia_Aer = MEA.Cd_Cia_Aer 
	Left Outer Join Comunicacao as Com_Consig on hea.cd_consig_hea=Com_Consig.cd_pes and com_consig.cd_tp_com='HBL'
	Left Outer Join Localidade as Origem on Origem.Cd_Local = MEA.Cd_Org_MEA
	Left Outer Join Localidade as Destino on Destino.Cd_Local = MEA.Cd_Dst_MEA
	Left Outer Join Localidade as GateWay on GateWay.Cd_Local = MEA.Cd_Gat_MEA
	Left Outer Join Volume_Exp_Aer as VEA on VEA.Num_Proc_HEA  = HEA.Num_Proc_HEA and VEA.Item_EA = '01'

	Left Outer Join PO_HEA as PO on PO.Num_Proc_HEA = HEA.Num_Proc_HEA

	Left Outer Join Prd_hou_exp_aer as Prd on Prd.Num_Proc_HEA = HEA.Num_Proc_HEA

	Left Outer Join Handling_HEA as Hand on Hand.Num_Proc_HEA = HEA.Num_Proc_HEA
	
Where 
	HEA.Num_Proc_HEA = @Num_Proc



GO
