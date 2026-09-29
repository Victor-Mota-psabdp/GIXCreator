SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE    Procedure	 spCSR_Rel  --'10-25-2007'


(
	
	@Data datetime
)

As
	Select
		HOU.Num_Proc_HEM 			BDP_Reference,
		Convert(Datetime,HOU.Dt_Emis_HEM,105) 	Register_Date,
		OC.Apelido				Ordering_Customer,
		CS.APelido				Consignee,
		LC.Pais_Local				Country_Destination,
		DPP.GMID				Product_Code,
		DPP.GMID_Descr_Curta			Product_Description,
		PD.Peso_Item				Net_Weigth,
		LLP.ETD_LEM				ETD_Date,
		LLP.ATD_LEM				Date_Departure,
		LLP.ETA_LEM				ETA_Date,
		LLP.ATA_LEM				Date_Arrival,
		HOU.Navio_HEM				Vessel_Name,
		JOB.Nr_Reserva				Booking_Number,
		P.Customer_PO				Customer_PO,
		HOU.Cd_Tp_Oper				Incoterms,
		CRR.Nome_Armador			Carrier_Name,
		HOU.HAWB_HEM				Bill_Lading_Number
		
	from 
		House_Exp_MAR HOU
	Left Outer Join LLP_Exp_MAR	LLP	on HOU.Num_Proc_HEM = LLP.Num_Proc_LEM
	Left Outer Join Pessoa		OC	On LLP.Cd_Order	= OC.Cd_Pes
	Left Outer Join Pessoa		CS	on Hou.Cd_Consig_HEM = CS.Cd_Pes
	Left Outer Join Localidade 	LC	on hou.Cd_Dst_HEM = LC.Cd_Local
	Left Outer Join Pedido_Ship 	PS	on HOU.Num_Proc_HEM = PS.Num_Proc
	Left Outer Join Pedido_Det	PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
	Left Outer Join De_Para_Produto DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Job_Exp_Mar	JOB	on HOU.Num_Proc_Hem = JOB.Num_Proc_Hem
	Left Outer Join Armador		CRR	on LLP.Cd_Armador_Lem = CRR.Cd_Armador 

	where convert(datetime,Dt_Emis_Hem,105) > @Data
	






GO
