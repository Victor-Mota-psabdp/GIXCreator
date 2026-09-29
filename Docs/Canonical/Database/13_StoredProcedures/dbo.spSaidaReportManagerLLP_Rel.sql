SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select top 1 * from pedido
--spSaidaReportManagerLLP_Rel 'EMCSR201108020BR'
--Incluido o Courier processo -05/10/2015 -Cadu

CREATE Procedure [dbo].[spSaidaReportManagerLLP_Rel]--'EMOXT201509001BR'
	@Num_Proc Varchar(16)
as

Declare @Parametro Int
Set @parametro=10

select
	replace(Intl_ref_lia,' ','') Intl_Ref, Num_proc_lia Job, ETA_LIA ETA, ETD_LIA ETD, ATA_LIA ATA, ATD_LIA ATD, Canal_lia Canal,
	'LCL' TypeOfCargo,PO_Req_Date,original_eta_lia Original_ETA,Vlr_Invoice,Cd_Moeda_Invoice, Null DL_Draft,Null DL_Carga,
	--COU.Apelido Courier, 
	NULL Courier,
	--LLP.Courier_number_lia Courier_Num, 
	--CP1.Num_Courier Courier_Num,	
	NULL Courier_Num,
	IT.apelido Inland_Trucker, DSTF.Pais_Local DestinoFinal, LLP.DL_Cargo_LIA DeadTerminal, LLP.Banco Banco, 
	LLP.Cd_Moeda_Invoice MoedaInvoice
From
	LLP_Imp_aer LLP With(Nolock)
	--left join Pessoa COU With(Nolock)	on COU.cd_pes = LLP.Cd_Courier
	left join Pessoa IT With(Nolock)	on IT.Cd_pes = LLP.Cd_Transportadora
	left join Localidade DSTF With(Nolock)	on DSTF.cd_Local = LLP.Cd_DstFinal_lia
	left join Courier_Processo CP1 with(nolock) on CP1.num_proc = LLP.Num_Proc_Lia and CP1.ID_Item = 1
	left join Pessoa COU With(Nolock)	on COU.cd_pes = CP1.Cd_Pes
Where
	Num_Proc_lia=@Num_Proc
		

UNION

select 
	replace(Intl_ref_lim,' ','') Intl_Ref,Num_proc_liM Job, ETA_LIM ETA, ETD_LIM ETD, ATA_LIM ATA, ATD_LIM ATD, Canal_liM Canal,
	nome_tp_carga,PO_Req_Date,Original_ETA_LIM Original_ETA,Vlr_Invoice,Cd_Moeda_Invoice, Null DL_Draft,Null DL_Carga,
	--COU.Apelido Courier ,
	NULL Courier,
	--LLP.Courier_number_lim Courier_Num, 
	--CP1.Num_Courier Courier_Num,	
	NULL Courier_Num,
	IT.apelido Inland_Trucker, DSTF.Pais_Local DestinoFinal, LLP.DL_Cargo_LIM DeadTerminal, LLP.Banco Banco, LLP.Cd_Moeda_Invoice MoedaInvoice
From
	LLP_Imp_mAR LLP With(Nolock)
	Join Tipo_Carga TC With(Nolock)	on TC.cd_tp_carga=llp.cd_tp_carga
	--left join Pessoa COU With(Nolock)	on COU.cd_pes = LLP.Cd_Courier
	left join Pessoa IT With(Nolock)	on IT.Cd_pes = LLP.Cd_Transportadora
	left join Localidade DSTF With(Nolock) on DSTF.cd_Local = LLP.Cd_DstFinal_lim
	left join Courier_Processo CP1 with(nolock) on CP1.num_proc = LLP.Num_Proc_Lim and CP1.ID_Item = 1
	left join Pessoa COU With(Nolock)	on COU.cd_pes = CP1.Cd_Pes
Where
	Num_Proc_liM=@Num_PRoc

union

select 
	replace(Intl_ref_lio,' ','') Intl_Ref, Num_proc_liO Job, ETA_LIO ETA, ETD_LIo ETD, ATA_LIo ATA, ATD_LIo ATD, Canal_lio Canal,
	null,PO_Req_Date,original_Eta_lio,Vlr_Invoice,Cd_Moeda_Invoice, Null DL_Draft,Null DL_Carga, 
	--COU.Apelido Courier, 
	NULL Courier,
	--LLP.Courier_number_lio Courier_Num,
	--CP1.Num_Courier Courier_Num,
	NULL Courier_Num,
	IT.apelido Inland_Trucker, DSTF.Pais_Local DestinoFinal, LLP.DL_Cargo_LIO DeadTerminal, LLP.Banco Banco, LLP.Cd_Moeda_Invoice MoedaInvoice
From
	LLP_Imp_out LLP With(Nolock)
	--left join Pessoa COU With(Nolock)		on COU.cd_pes = LLP.Cd_Courier
	left join Pessoa IT With(Nolock)			on IT.Cd_pes = LLP.Cd_Transportadora
	left join Localidade DSTF With(Nolock)	on DSTF.cd_Local = LLP.Cd_DstFinal_lio
	left join Courier_Processo CP1 with(nolock) on CP1.num_proc = LLP.Num_Proc_Lio and CP1.ID_Item = 1
	left join Pessoa COU With(Nolock)		on COU.cd_pes = CP1.Cd_Pes
Where
	Num_Proc_lio=@Num_Proc

union

select top 1
	null, Num_proc_lea Job, ETA_lea ETA, ETD_lea ETD, ATA_lea ATA, ATD_lea ATD, Canal_lea Canal,null,PO_Req_Date,original_eta_lea,
	null,P.cd_tp_moeda, Null DL_Draft,Null DL_Carga, 
	--COU.Apelido Courier, 
	NULL Courier,
	--LLP.Courier_number_lea Courier_Num,
	--CP1.Num_Courier Courier_Num, 
	NULL Courier_Num,
	IT.apelido Inland_Trucker, DSTF.Pais_Local DestinoFinal, LLP.DL_Cargo_LEA DeadTerminal, LLP.Banco Banco, isnull(LLP.Cd_Moeda_Invoice,P.cd_tp_moeda) MoedaInvoice
from
	LLP_exp_aer LLP With(Nolock)
	--left join Pessoa COU With(Nolock) on COU.cd_pes = LLP.Cd_Courier
	left join Pessoa IT With(Nolock) on IT.Cd_pes = LLP.Cd_Transportadora
	left join Localidade DSTF With(Nolock) on DSTF.cd_Local = LLP.Cd_DstFinal_lea
	left join invoice_cliente INV With(Nolock) on INV.num_proc = @Num_Proc --para pegar o vlr_invoice nos casos de invoice (EXP) criada no ATL - Claudio
	left join pedido_ship PS With(Nolock) on PS.num_proc = @Num_Proc
	left join pedido P With(Nolock) on P.cd_pedido = PS.cd_pedido --para pegar o cd_tp_moeda (moeda da invoice) para os casos de EXP  - Claudio
	left join Courier_Processo CP1 with(nolock) on CP1.num_proc = LLP.Num_Proc_Lea and CP1.ID_Item = 1
	left join Pessoa COU With(Nolock) on COU.cd_pes = CP1.Cd_Pes
where
	Num_Proc_lea=@Num_Proc

UNION

select top 1
	null,Num_proc_lem Job, ETA_lem ETA, ETD_lem ETD, ATA_lem ATA, ATD_lem ATD, Canal_lem Canal,Nome_tp_carga,PO_Req_Date,
	original_eta_lem,null,P.cd_tp_moeda, DL_Draft_Lem DL_Draft,DL_Cargo_Lem DL_Carga,
	--COU.Apelido Courier, 
	NULL Courier,
	--LLP.Courier_number_lem Courier_Num,
	--CP1.Num_Courier Courier_Num, 
	NULL Courier_Num,
	IT.apelido Inland_Trucker, DSTF.Pais_Local DestinoFinal, LLP.DL_Cargo_LEM DeadTerminal, LLP.Banco Banco, isnull(LLP.Cd_Moeda_Invoice,P.cd_tp_moeda) MoedaInvoice
from
	LLP_exp_mAR LLP  With(Nolock)
	Left Join Tipo_Carga TC With(Nolock) on TC.cd_tp_carga=llp.cd_tp_carga
	--left join Pessoa COU With(Nolock)	on COU.cd_pes = LLP.Cd_Courier
	left join Pessoa IT With(Nolock)		on IT.Cd_pes = LLP.Cd_Transportadora
	left join Localidade DSTF With(Nolock)	on DSTF.cd_Local = LLP.Cd_DstFinal_lem
	left join invoice_cliente INV With(Nolock) on INV.num_proc = @Num_Proc --para pegar o vlr_invoice nos casos de invoice (EXP) criada no ATL - Claudio
	left join pedido_ship PS With(Nolock) on PS.num_proc = @Num_Proc
	left join pedido P With(Nolock) on P.cd_pedido = PS.cd_pedido --para pegar o cd_tp_moeda (moeda da invoice) para os casos de EXP  - Claudio
	left join Courier_Processo CP1 with(nolock) on CP1.num_proc = LLP.Num_Proc_Lem and CP1.ID_Item = 1
	left join Pessoa COU With(Nolock) on COU.cd_pes = CP1.Cd_Pes
where
	Num_Proc_lem=@Num_Proc

union

select top 1
	null,Num_proc_leo Job, ETA_leo ETA, ETD_leo ETD, ATA_leo ATA, ATD_leo ATD, Canal_leo Canal,null,PO_Req_Date,original_Eta_leo,
	null,P.cd_tp_moeda,null,null,
	--COU.Apelido Courier,
	NULL Courier,
	--LLP.Courier_number_leo Courier_Num,
	--CP1.Num_Courier Courier_Num, 
	NULL Courier_Num,
	IT.apelido Inland_Trucker, DSTF.Pais_Local DestinoFinal, LLP.DL_Cargo_LEO DeadTerminal, LLP.Banco Banco, isnull(LLP.Cd_Moeda_Invoice,P.cd_tp_moeda) MoedaInvoice
from
	LLP_exp_out LLP With(Nolock)
	--left join Pessoa COU With(Nolock)	on COU.cd_pes = LLP.Cd_Courier
	left join Pessoa IT With(Nolock)		on IT.Cd_pes = LLP.Cd_Transportadora
	left join Localidade DSTF With(Nolock)	on DSTF.cd_Local = LLP.Cd_DstFinal_leo
	left join invoice_cliente INV With(Nolock) on INV.num_proc = @Num_Proc --para pegar o vlr_invoice nos casos de invoice (EXP) criada no ATL - Claudio
	left join pedido_ship PS With(Nolock) on PS.num_proc = @Num_Proc
	left join pedido P With(Nolock) on P.cd_pedido = PS.cd_pedido --para pegar o cd_tp_moeda (moeda da invoice) para os casos de EXP  - Claudio
	left join Courier_Processo CP1 with(nolock) on CP1.num_proc = LLP.Num_Proc_Leo and CP1.ID_Item = 1
	left join Pessoa COU With(Nolock) on COU.cd_pes = CP1.Cd_Pes
where
	Num_Proc_leo=@Num_Proc
	
	
	
	
/* stored antiga
ALTER Procedure [dbo].[spSaidaReportManagerLLP_Rel]
	@Num_Proc Varchar(16)
as

Declare @Parametro Int
Set @parametro=10

select
	replace(Intl_ref_lia,' ','') Intl_Ref, Num_proc_lia Job, ETA_LIA ETA, ETD_LIA ETD, ATA_LIA ATA, ATD_LIA ATD, Canal_lia Canal,'LCL' TypeOfCargo,PO_Req_Date,original_eta_lia Original_ETA,Vlr_Invoice,Cd_Moeda_Invoice, Null DL_Draft,Null DL_Carga,COU.Apelido Courier, 
	LLP.Courier_number_lia Courier_Num, IT.apelido Inland_Trucker, DSTF.Pais_Local DestinoFinal, LLP.DL_Cargo_LIA DeadTerminal, LLP.Banco Banco, LLP.Cd_Moeda_Invoice MoedaInvoice
From
	LLP_Imp_aer LLP With(Nolock)
	left join Pessoa COU With(Nolock)	on COU.cd_pes = LLP.Cd_Courier
	left join Pessoa IT With(Nolock)	on IT.Cd_pes = LLP.Cd_Transportadora
	left join Localidade DSTF With(Nolock)	on DSTF.cd_Local = LLP.Cd_DstFinal_lia
Where
	Num_Proc_lia=@Num_Proc
		

UNION

select 
	replace(Intl_ref_lim,' ','') Intl_Ref,Num_proc_liM Job, ETA_LIM ETA, ETD_LIM ETD, ATA_LIM ATA, ATD_LIM ATD, Canal_liM Canal,nome_tp_carga,PO_Req_Date,Original_ETA_LIM Original_ETA,Vlr_Invoice,Cd_Moeda_Invoice, Null DL_Draft,Null DL_Carga,COU.Apelido Courier ,
	LLP.Courier_number_lim Courier_Num, IT.apelido Inland_Trucker, DSTF.Pais_Local DestinoFinal, LLP.DL_Cargo_LIM DeadTerminal, LLP.Banco Banco, LLP.Cd_Moeda_Invoice MoedaInvoice
From
	LLP_Imp_mAR LLP With(Nolock)
	Join Tipo_Carga TC With(Nolock)	on TC.cd_tp_carga=llp.cd_tp_carga
	left join Pessoa COU With(Nolock)	on COU.cd_pes = LLP.Cd_Courier
	left join Pessoa IT With(Nolock)	on IT.Cd_pes = LLP.Cd_Transportadora
	left join Localidade DSTF With(Nolock) on DSTF.cd_Local = LLP.Cd_DstFinal_lim
Where
	Num_Proc_liM=@Num_PRoc

union

select 
	replace(Intl_ref_lio,' ','') Intl_Ref, Num_proc_liO Job, ETA_LIO ETA, ETD_LIo ETD, ATA_LIo ATA, ATD_LIo ATD, Canal_lio Canal,null,PO_Req_Date,original_Eta_lio,Vlr_Invoice,Cd_Moeda_Invoice, Null DL_Draft,Null DL_Carga, COU.Apelido Courier, 
	LLP.Courier_number_lio Courier_Num, IT.apelido Inland_Trucker, DSTF.Pais_Local DestinoFinal, LLP.DL_Cargo_LIO DeadTerminal, LLP.Banco Banco, LLP.Cd_Moeda_Invoice MoedaInvoice
From
	LLP_Imp_out LLP With(Nolock)
	left join Pessoa COU With(Nolock)		on COU.cd_pes = LLP.Cd_Courier
	left join Pessoa IT With(Nolock)			on IT.Cd_pes = LLP.Cd_Transportadora
	left join Localidade DSTF With(Nolock)	on DSTF.cd_Local = LLP.Cd_DstFinal_lio
Where
	Num_Proc_lio=@Num_Proc



union

select top 1
	null, Num_proc_lea Job, ETA_lea ETA, ETD_lea ETD, ATA_lea ATA, ATD_lea ATD, Canal_lea Canal,null,PO_Req_Date,original_eta_lea,null,P.cd_tp_moeda, Null DL_Draft,Null DL_Carga, COU.Apelido Courier, 
	LLP.Courier_number_lea Courier_Num, IT.apelido Inland_Trucker, DSTF.Pais_Local DestinoFinal, LLP.DL_Cargo_LEA DeadTerminal, LLP.Banco Banco, isnull(LLP.Cd_Moeda_Invoice,P.cd_tp_moeda) MoedaInvoice
from
	LLP_exp_aer LLP With(Nolock)
	left join Pessoa COU With(Nolock) on COU.cd_pes = LLP.Cd_Courier
	left join Pessoa IT With(Nolock) on IT.Cd_pes = LLP.Cd_Transportadora
	left join Localidade DSTF With(Nolock) on DSTF.cd_Local = LLP.Cd_DstFinal_lea
	left join invoice_cliente INV With(Nolock) on INV.num_proc = @Num_Proc --para pegar o vlr_invoice nos casos de invoice (EXP) criada no ATL - Claudio
	left join pedido_ship PS With(Nolock) on PS.num_proc = @Num_Proc
	left join pedido P With(Nolock) on P.cd_pedido = PS.cd_pedido --para pegar o cd_tp_moeda (moeda da invoice) para os casos de EXP  - Claudio
where
	Num_Proc_lea=@Num_Proc

UNION

select top 1
	null,Num_proc_lem Job, ETA_lem ETA, ETD_lem ETD, ATA_lem ATA, ATD_lem ATD, Canal_lem Canal,Nome_tp_carga,PO_Req_Date,original_eta_lem,null,P.cd_tp_moeda, DL_Draft_Lem DL_Draft,DL_Cargo_Lem DL_Carga, COU.Apelido Courier, 
	LLP.Courier_number_lem Courier_Num, IT.apelido Inland_Trucker, DSTF.Pais_Local DestinoFinal, LLP.DL_Cargo_LEM DeadTerminal, LLP.Banco Banco, isnull(LLP.Cd_Moeda_Invoice,P.cd_tp_moeda) MoedaInvoice
from
	LLP_exp_mAR LLP  With(Nolock)
	Left Join Tipo_Carga TC With(Nolock) on TC.cd_tp_carga=llp.cd_tp_carga
	left join Pessoa COU With(Nolock)	on COU.cd_pes = LLP.Cd_Courier
	left join Pessoa IT With(Nolock)		on IT.Cd_pes = LLP.Cd_Transportadora
	left join Localidade DSTF With(Nolock)	on DSTF.cd_Local = LLP.Cd_DstFinal_lem
	left join invoice_cliente INV With(Nolock) on INV.num_proc = @Num_Proc --para pegar o vlr_invoice nos casos de invoice (EXP) criada no ATL - Claudio
	left join pedido_ship PS With(Nolock) on PS.num_proc = @Num_Proc
	left join pedido P With(Nolock) on P.cd_pedido = PS.cd_pedido --para pegar o cd_tp_moeda (moeda da invoice) para os casos de EXP  - Claudio
where
	Num_Proc_lem=@Num_Proc

union

select top 1
	null,Num_proc_leo Job, ETA_leo ETA, ETD_leo ETD, ATA_leo ATA, ATD_leo ATD, Canal_leo Canal,null,PO_Req_Date,original_Eta_leo,null,P.cd_tp_moeda,null,null,COU.Apelido Courier,
	LLP.Courier_number_leo Courier_Num, IT.apelido Inland_Trucker, DSTF.Pais_Local DestinoFinal, LLP.DL_Cargo_LEO DeadTerminal, LLP.Banco Banco, isnull(LLP.Cd_Moeda_Invoice,P.cd_tp_moeda) MoedaInvoice
from
	LLP_exp_out LLP With(Nolock)
	left join Pessoa COU With(Nolock)	on COU.cd_pes = LLP.Cd_Courier
	left join Pessoa IT With(Nolock)		on IT.Cd_pes = LLP.Cd_Transportadora
	left join Localidade DSTF With(Nolock)	on DSTF.cd_Local = LLP.Cd_DstFinal_leo
	left join invoice_cliente INV With(Nolock) on INV.num_proc = @Num_Proc --para pegar o vlr_invoice nos casos de invoice (EXP) criada no ATL - Claudio
	left join pedido_ship PS With(Nolock) on PS.num_proc = @Num_Proc
	left join pedido P With(Nolock) on P.cd_pedido = PS.cd_pedido --para pegar o cd_tp_moeda (moeda da invoice) para os casos de EXP  - Claudio
where
	Num_Proc_leo=@Num_Proc
*/


























GO
