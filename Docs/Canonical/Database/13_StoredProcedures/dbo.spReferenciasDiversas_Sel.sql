SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE	PROCEDURE [dbo].[spReferenciasDiversas_Sel] --'EMCSR20080100201'
(
@Processo		VarChar(16)
)
AS

If Left(@Processo,2)='IO'
Begin
	Select  
		Agente.Apelido			Agente,
		Null					Nr_Reserva,
		LLP.Canal_Lio			Canal,
		CHB.Apelido 			CHB,
		CSR.Nome_Usuario		Customer,
		SAP_ShipNumber 			SAP,
		TP.NOMe_Tp_Oper			Incoterm,
		Forwarder.Apelido		Forwarder,
		LLP.Intl_Ref_LIO		Intl_ref,
		OD.Apelido				Order_Pes,
		Sales.Nome_Usuario		Vendedor,
		TERM.Nome_Terminal		Terminal,
		TTime_d					TTime_d,
		Transp.Apelido			Transportadora,
		Vlr_Invoice,
		TM_INV.Nome_Tp_Moeda	Moeda_INV,
		LLP.Banco,
		null					Paridade_Oper
	From
		LLP_IMP_OUT	LLP
		Left Outer Join House_IMP_OUT HOU		on HOU.Num_proc_HIO = LLP.Num_proc_LIO
--		Left Outer Join LLP_ARG		ARG			on LLP.Num_proc_LIO=ARG.Num_Proc
		Left Outer Join Pessoa		CHB			on LLP.Cd_Despachante = CHB.Cd_Pes	
		Left Outer Join Pessoa		Agente		on LLP.Cd_Agente = Agente.Cd_Pes
		Left Outer Join Pessoa		Forwarder	on LLP.Cd_Forwarder = Forwarder.Cd_Pes
		Left Outer Join Usuario		Sales		on LLP.Cd_Vendedor = Sales.Cd_Usuario
		Left Outer Join Usuario		CSR			on LLP.Cd_Usuario = CSR.Cd_Usuario
		Left Outer Join Tipo_Moeda	TM_INV		on LLP.Cd_Moeda_Invoice = TM_INV.Cd_Tp_Moeda
		Left Outer Join Pessoa		OD			on LLP.Cd_Order = OD.Cd_Pes
		Left Outer Join Terminal	TERM		on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Outer Join Pessoa		Transp		on LLP.Cd_Transportadora = Transp.Cd_Pes
		Left Outer Join Tipo_Oper	TP			on HOU.cd_tp_oper = TP.Cd_tp_oper
	Where
		HOU.Num_Proc_HIO= @Processo
End

Else If Left(@Processo,2)='IM'
Begin
	Select
		Agente.Apelido			Agente,
								Nr_Reserva,
		LLP.Canal_LIM			Canal,
		CHB.Apelido 			CHB,
		CSR.Nome_Usuario		Customer,
		SAP_ShipNumber 			SAP,
		TP.NOMe_Tp_Oper			Incoterm,
		Forwarder.Apelido		Forwarder,
		LLP.Intl_Ref_LIM		Intl_ref,
		OD.Apelido				Order_Pes,
		Sales.Nome_Usuario		Vendedor,
		TERM.Nome_Terminal		Terminal,
		TTime_d					TTime_d,
		Transp.Apelido			Transportadora,
		Vlr_Invoice,
		TM_INV.Nome_Tp_Moeda	Moeda_INV,
		LLP.Banco,
		null					Paridade_Oper
	From
		LLP_IMP_Mar	LLP
		Left Join House_IMP_Mar HOU			on HOU.Num_proc_HIM = LLP.Num_proc_LIM
		Left Join Job_Imp_Mar	JOB			on HOU.Num_Proc_HIM = JOB.Num_Proc_HIM
--		Left Join LLP_ARG		ARG			on LLP.Num_proc_LIM=ARG.Num_Proc
		Left Join Pessoa		CHB			on HOU.Cd_Despachante = CHB.Cd_Pes	
		Left Join Pessoa		Agente		on JOB.Cd_Agente = Agente.Cd_Pes
		Left Join Pessoa		Forwarder	on LLP.Cd_Forwarder = Forwarder.Cd_Pes
		Left Join Usuario		Sales		on JOB.Cd_Vendedor = Sales.Cd_Usuario
		Left Join Usuario		CSR			on JOB.Cd_Usuario = CSR.Cd_Usuario
		Left Join Tipo_Moeda	TM_INV		on LLP.Cd_Moeda_Invoice = TM_INV.Cd_Tp_Moeda
		Left Join Pessoa		OD			on LLP.Cd_Order = OD.Cd_Pes
		Left Join Terminal		TERM		on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join Pessoa		Transp		on LLP.Cd_Transportadora = Transp.Cd_Pes
		Left Join Tipo_Oper		TP			on HOU.cd_tp_oper = TP.Cd_tp_oper
	Where
		HOU.Num_Proc_HIM=@Processo
End
Else If Left(@Processo,2)='IA'
Begin
	Select
		Agente.Apelido			Agente,
		Null					Nr_Reserva,
		LLP.Canal_LIA			Canal,
		CHB.Apelido 			CHB,
		CSR.Nome_Usuario		Customer,
		SAP_ShipNumber 			SAP,
		TP.NOMe_Tp_Oper			Incoterm,
		Forwarder.Apelido		Forwarder,
		LLP.Intl_Ref_LIA		Intl_ref,
		OD.Apelido				Order_Pes,
		Sales.Nome_Usuario		Vendedor,
		TERM.Nome_Terminal		Terminal,
		TTime_d					TTime_d,
		Transp.Apelido			Transportadora,
		Vlr_Invoice,
		TM_INV.Nome_Tp_Moeda	Moeda_INV,
		LLP.Banco,
		null					Paridade_Oper
	From
		LLP_IMP_Aer	LLP
		Left Join House_IMP_Aer HOU			on HOU.Num_proc_HIA = LLP.Num_proc_LIA
		Left Join Job_Imp_Aer	JOB			on HOU.Num_Proc_HIA = JOB.Num_Proc_HIA
--		Left Join LLP_ARG		ARG			on LLP.Num_proc_LIA=ARG.Num_Proc
		Left Join Pessoa		CHB			on HOU.Cd_Dsp_HIA = CHB.Cd_Pes	
		Left Join Pessoa		Agente		on JOB.Cd_Agente = Agente.Cd_Pes
		Left Join Pessoa		Forwarder	on LLP.Cd_Forwarder = Forwarder.Cd_Pes
		Left Join Usuario		Sales		on JOB.Cd_Vendedor = Sales.Cd_Usuario
		Left Join Usuario		CSR			on JOB.Cd_Usuario = CSR.Cd_Usuario
		Left Join Tipo_Moeda	TM_INV		on LLP.Cd_Moeda_Invoice = TM_INV.Cd_Tp_Moeda
		Left Join Pessoa		OD			on LLP.Cd_Order = OD.Cd_Pes
		Left Join Terminal		TERM		on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join Pessoa		Transp		on LLP.Cd_Transportadora = Transp.Cd_Pes
		Left Join Tipo_Oper		TP			on HOU.cd_tp_oper = TP.Cd_tp_oper
	Where
		HOU.Num_Proc_HIA=@Processo
End
Else IF left(@Processo,2)='EO'
Begin
	Select  
		Agente.Apelido			Agente,
		Null					Nr_Reserva,
		Comissao_Agente_LEO		Comissao_Agente,
		LLP.Canal_LEO			Canal,
		CHB.Apelido 			CHB,
		CSR.Nome_Usuario		Customer,
		SAP_ShipNumber 			SAP,
		TP.NOMe_Tp_Oper			Incoterm,
		Forwarder.Apelido		Forwarder,
		LLP.Intl_Ref_LEO		Intl_ref,
		NTF.Apelido				Notify_2,
		OD.Apelido				Order_Pes,
		Sales.Nome_Usuario		Vendedor,
		TERM.Nome_Terminal		Terminal,
		TTime_d					TTime_d,
		Transp.Apelido			Transportadora,
		Vlr_Invoice,
		TM_INV.Nome_Tp_Moeda	Moeda_INV,
		LLP.Banco,
		null					Paridade_Oper
	From
		LLP_Exp_OUT	LLP
		Left Outer Join House_Exp_OUT HOU		on HOU.Num_proc_HEO = LLP.Num_proc_LEO
		Left Outer Join Pessoa		CHB			on LLP.Cd_Despachante = CHB.Cd_Pes	
		Left Outer Join Pessoa		Agente		on LLP.Cd_Agente = Agente.Cd_Pes
		Left Outer Join Pessoa		Forwarder	on LLP.Cd_Forwarder = Forwarder.Cd_Pes
		Left Outer Join Usuario		Sales		on LLP.Cd_Vendedor = Sales.Cd_Usuario
		Left Outer Join Usuario		CSR			on LLP.Cd_Usuario = CSR.Cd_Usuario
		Left Outer Join Tipo_Moeda	TM_INV		on LLP.Cd_Moeda_Invoice = TM_INV.Cd_Tp_Moeda
		Left Outer Join Pessoa		OD			on LLP.Cd_Order = OD.Cd_Pes
		Left Outer Join Terminal	TERM		on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Outer Join Pessoa		Transp		on LLP.Cd_Transportadora = Transp.Cd_Pes
		Left Outer Join Tipo_Oper	TP			on HOU.cd_tp_oper = TP.Cd_tp_oper
		Left Outer Join Pessoa		NTF			on LLP.Cd_Notify_2 = NTF.Cd_Pes
	Where
		HOU.Num_Proc_HEO= @Processo
End

Else IF left(@Processo,2)='EM'
Begin
	Select
		Agente.Apelido			Agente,
		Comissao_Agente_LEM		Comissao_Agente,
								Nr_Reserva,
		LLP.Canal_LEM			Canal,
		CHB.Apelido 			CHB,
		CSR.Nome_Usuario		Customer,
		SAP_ShipNumber 			SAP,
		TP.NOMe_Tp_Oper			Incoterm,
		Forwarder.Apelido		Forwarder,
		LLP.Intl_Ref_LEM		Intl_ref,
		NTF.Apelido				Notify_2,
		OD.Apelido				Order_Pes,
		Sales.Nome_Usuario		Vendedor,
		TERM.Nome_Terminal		Terminal,
		TTime_d					TTime_d,
		Transp.Apelido			Transportadora,
		Vlr_Invoice,
		TM_INV.Nome_Tp_Moeda	Moeda_INV,
		LLP.Banco,
		null					Paridade_Oper
	From
		LLP_Exp_Mar	LLP
		Left Join House_Exp_Mar HOU			on HOU.Num_proc_HEM = LLP.Num_proc_LEM
		Left Join Job_Exp_Mar	JOB			on HOU.Num_Proc_HEM = JOB.Num_Proc_HEM
		Left Join Pessoa		CHB			on HOU.Cd_Dsp_HEM = CHB.Cd_Pes	
		Left Join Pessoa		Agente		on JOB.Cd_Agente = Agente.Cd_Pes
		Left Join Pessoa		Forwarder	on LLP.Cd_Forwarder = Forwarder.Cd_Pes
		Left Join Usuario		Sales		on JOB.Cd_Vendedor = Sales.Cd_Usuario
		Left Join Usuario		CSR			on JOB.Cd_Usuario = CSR.Cd_Usuario
		Left Join Tipo_Moeda	TM_INV		on LLP.Cd_Moeda_Invoice = TM_INV.Cd_Tp_Moeda
		Left Join Pessoa		OD			on LLP.Cd_Order = OD.Cd_Pes
		Left Join Terminal		TERM		on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join Pessoa		Transp		on LLP.Cd_Transportadora = Transp.Cd_Pes
		Left Join Tipo_Oper		TP			on HOU.cd_tp_oper = TP.Cd_tp_oper
		Left Join Pessoa		NTF			on LLP.Cd_Notify_2 = NTF.Cd_Pes
	Where
		HOU.Num_Proc_HEM=@Processo
End

Else IF left(@Processo,2)='EA'
Begin
	Select
		Agente.Apelido			Agente,
		Comissao_Agente_LEA		Comissao_Agente,
		null					Nr_Reserva,
		LLP.Canal_LEA			Canal,
		CHB.Apelido 			CHB,
		CSR.Nome_Usuario		Customer,
		SAP_ShipNumber 			SAP,
		TP.NOMe_Tp_Oper			Incoterm,
		Forwarder.Apelido		Forwarder,
		LLP.Intl_Ref_LEA		Intl_ref,
		NTF.Apelido				Notify_2,
		OD.Apelido				Order_Pes,
		Sales.Nome_Usuario		Vendedor,
		TERM.Nome_Terminal		Terminal,
		TTime_d					TTime_d,
		Transp.Apelido			Transportadora,
		Vlr_Invoice,
		TM_INV.Nome_Tp_Moeda	Moeda_INV,
		LLP.Banco,
		null					Paridade_Oper
	From
		LLP_Exp_Aer	LLP
		Left Join House_Exp_Aer HOU			on HOU.Num_proc_HEA = LLP.Num_proc_LEA
		Left Join Job_Exp_Aer	JOB			on HOU.Num_Proc_HEA = JOB.Num_Proc_HEA
		Left Join Pessoa		CHB			on HOU.Cd_Dsp_HEA = CHB.Cd_Pes	
		Left Join Pessoa		Agente		on JOB.Cd_Agente = Agente.Cd_Pes
		Left Join Pessoa		Forwarder	on LLP.Cd_Forwarder = Forwarder.Cd_Pes
		Left Join Usuario		Sales		on JOB.Cd_Vendedor = Sales.Cd_Usuario
		Left Join Usuario		CSR			on JOB.Cd_Usuario = CSR.Cd_Usuario
		Left Join Tipo_Moeda	TM_INV		on LLP.Cd_Moeda_Invoice = TM_INV.Cd_Tp_Moeda
		Left Join Pessoa		OD			on LLP.Cd_Order = OD.Cd_Pes
		Left Join Terminal		TERM		on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join Pessoa		Transp		on LLP.Cd_Transportadora = Transp.Cd_Pes
		Left Join Tipo_Oper		TP			on HOU.cd_tp_oper = TP.Cd_tp_oper
		Left Join Pessoa		NTF			on LLP.Cd_Notify_2 = NTF.Cd_Pes
	Where
		HOU.Num_Proc_HEA=@Processo
End






GO
