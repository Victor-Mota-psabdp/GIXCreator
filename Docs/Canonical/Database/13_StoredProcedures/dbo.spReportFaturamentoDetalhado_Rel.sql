SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----[spReportFaturamentoDetalhado_Rel] '60.435.351/0047-30','2021-07-19','2021-07-25'
--[spReportFaturamentoDetalhado_Rel]'60.435.351/0003-19','2021-06-15','2021-06-25', '','','Adiantamento'
--[spReportFaturamentoDetalhado_Rel]'','2021-05-13','2021-08-11','109411 ','I','testenota'

--select * from vwPO_ALL where num_proc like 'EMSCSR2021%' and id_dc = 25

--select * from vwcta_Cte where Num_NF_HIA = '110870' and Ref_Acesso_NF_HIA = 'I'
--select * from tipo_taxa where cd_tp_tx = '2AK'
--select * from tipo_taxa where cd_tp_tx = 'srv'
--select * from fatura_chb where fatura_pc like 'IMCSR202104282BR%'
--select * from Fatura_CHB_Item where fatura_cc like 'IMCSR202104282BR%'
--select * from fatura where fatcod like 'IMCSR202104282BR%'
--select * from item_fat where fatcod like 'IMCSR202104282BR%'

CREATE Procedure [dbo].[spReportFaturamentoDetalhado_Rel]--'108802 ','I'
(	
	@Num_Cpf_Cnpj	varchar(50),
	@Initial_Date	DateTime,
	@Final_Date		DateTime,
	@Num_NF			Varchar(10),
	@Ref_Acesso		Varchar(20),
	@Requerimento	Varchar(250)
)

as

--Declare @Num_Cpf_Cnpj	varchar(50)
--Declare @Initial_Date	DateTime
--Declare	@Final_Date		DateTime

--set @Num_Cpf_Cnpj = '60.435.351/0047-30'
--set @Initial_Date = '2021-07-19'
--set	@Final_Date	= '2021-07-25'

--Um report para o BO, por CNPJ com o código 025 (Requerimento)
if @Num_NF = ''
	begin
		select distinct
			'Job ' + F.fatura_cc [Job], 			
			'PO ' + isnull(dbo.fBusca_TipoDocCliente('N',BO.Num_Proc,3),'') [PO],
			'MBL ' + isnull(A.MAWB,'')  MAWB,
			'HBL ' + isnull(A.HAWB,'')  HAWB,
			T.nome_tp_tx [Taxa], 
			F.Vlr_PC [valor],
			FC.Data_PC DataPC,
			'' NF,
			P.Nome_Raz_Soc,
			'CNPJ: ' + substring(num_cpf_cnpj,1,2) + '.' + substring(num_cpf_cnpj,3,3) + '.' + substring(num_cpf_cnpj,6,3)
			+ '/' + substring(num_cpf_cnpj,9,4) + '-' + substring(num_cpf_cnpj,13,2)   num_cpf_cnpj,
			'Requerimento: ' +isnull(dbo.fBusca_TipoDocCliente('N',BO.num_proc_HBO,25),@Requerimento) Requerimento,
			'obs: VALOR PAGO EM ADIANTAMENTO SEMANAL' Obs
		from fatura_chb FC
			join Pessoa P on P.cd_pes = FC.cd_pes_pc
			join Fatura_CHB_Item F on FC.fatura_pc = F.fatura_cc
			join Tipo_taxa T on T.cd_tp_tx = F.cd_tp_tx and T.Nome_Tp_Tx not like 'Adianta%'
			join JOB_HBO BO on BO.num_proc_HBO = FC.Processo_PC		
			left join vwCliente_Alerta A on A.num_proc = BO.Num_Proc
		where 
			P.num_cpf_cnpj = replace(replace(replace(@Num_Cpf_Cnpj,'.',''),'-',''),'/','')
			and FC.Data_PC between @Initial_Date and @Final_Date
			and	F.Tp_Pgto = 'B'
			and FC.status_pc = 'E'
			and FC.Processo_PC  like 'BO%'		
		order by 1 

	end
else
	begin
		select distinct
			'Job ' + F.fatura_cc [Job], 
			'PO ' + isnull(dbo.fBusca_TipoDocCliente('N',I.Num_Proc_HIA,3),'') [PO],
			'MBL ' + isnull(A.MAWB,'')  MAWB,
			'HBL ' + isnull(A.HAWB,'')  HAWB,
			T.nome_tp_tx [Taxa], 
			F.Vlr_PC [valor],
			'NF: ' + BA.RPS_NFE NF,
			P.Nome_Raz_Soc,
			'CNPJ: ' + substring(num_cpf_cnpj,1,2) + '.' + substring(num_cpf_cnpj,3,3) + '.' + substring(num_cpf_cnpj,6,3)
			+ '/' + substring(num_cpf_cnpj,9,4) + '-' + substring(num_cpf_cnpj,13,2)   num_cpf_cnpj,
			'Requerimento: ' + isnull(dbo.fBusca_TipoDocCliente('N',I.Num_Proc_HIA,25),@Requerimento) Requerimento,
				'obs: VALOR PAGO EM ADIANTAMENTO SEMANAL' Obs
		from vwcta_Cte I	
			join fatura_chb FC on FC.Processo_PC = I.Num_Proc_HIA and fc.cd_tipo = 'P'
			join Pessoa P on P.cd_pes = FC.cd_pes_pc
			join Fatura_CHB_Item F on FC.fatura_pc = F.fatura_cc
			join Tipo_taxa T on T.cd_tp_tx = F.cd_tp_tx and T.Nome_Tp_Tx not like 'Adianta%'
			join vwCliente_Alerta A on A.num_proc = I.Num_Proc_HIA
			left join Base_Nota_Fiscal BA on BA.nota_fiscal = I.num_nf_hia and BA.ref_acesso = I.ref_acesso_NF_hia
		where 
			I.Num_NF_HIA = @Num_NF and I.Ref_Acesso_NF_HIA = left(@Ref_Acesso,1)
			--and FC.Data_PC between @Initial_Date and @Final_Date
			and	F.Tp_Pgto = 'B'
			and FC.status_pc = 'E'
		order by 1 
	end


		
	
/*

ALTER Procedure [dbo].[spReportFaturamentoDetalhado_Rel]--'108802 ','I'
(
	@NF		varchar(50),
	@Site	varchar(25)
)

as


if left(@NF,1) = 'A'
	begin
		select 
			'Job ' + F.fatura_cc [Job], 
			'PO ' + isnull(dbo.fBusca_TipoDocCliente('N',FC.Processo_PC,3),'') [PO],
			'MBL ' + isnull(A.MAWB,B.MAWB)  MAWB,
			'HBL ' + isnull(A.HAWB,B.HAWB)  HAWB,
			T.nome_tp_tx [Taxa], 
			F.Vlr_PC [valor],
			@NF NF
		from vwPO_ALL I	
			join fatura_chb FC on FC.Processo_PC = I.Num_Proc and fc.cd_tipo = 'P'
			join Fatura_CHB_Item F on FC.fatura_pc = F.fatura_cc
			join Tipo_taxa T on T.cd_tp_tx = F.cd_tp_tx and T.Nome_Tp_Tx not like 'Adianta%'
			left join vwCliente_Alerta A on A.num_proc = FC.Processo_PC	
			left join JOB_HBO BO on BO.num_proc_HBO = FC.Processo_PC
			left join vwCliente_Alerta B on B.num_proc = BO.num_proc			
		where 
			I.id_dc = 25 and numero_po like @NF + '%'
			--and FC.fatura_pc like 'BO%'
			and	F.Tp_Pgto = 'B'
			and FC.status_pc = 'E'			
		order by 1 

	end
else
	begin
		select 
			'Job ' + F.fatura_cc [Job], 
			'PO ' + isnull(dbo.fBusca_TipoDocCliente('N',I.Num_Proc_HIA,3),'') [PO],
			'MBL ' + isnull(A.MAWB,'')  MAWB,
			'HBL ' + isnull(A.HAWB,'')  HAWB,
			T.nome_tp_tx [Taxa], 
			F.Vlr_PC [valor],
			BA.RPS_NFE NF
		from vwcta_Cte I	
			join fatura_chb FC on FC.Processo_PC = I.Num_Proc_HIA and fc.cd_tipo = 'P'
			join Fatura_CHB_Item F on FC.fatura_pc = F.fatura_cc
			join Tipo_taxa T on T.cd_tp_tx = F.cd_tp_tx and T.Nome_Tp_Tx not like 'Adianta%'
			join vwCliente_Alerta A on A.num_proc = I.Num_Proc_HIA
			left join Base_Nota_Fiscal BA on BA.nota_fiscal = I.num_nf_hia and BA.ref_acesso = I.ref_acesso_NF_hia
		where 
			I.Num_NF_HIA = @NF and I.Ref_Acesso_NF_HIA = left(@Site,1)
			--I.Num_NF_HIA = '108802' and I.Ref_Acesso_NF_HIA = 'I'
			and	F.Tp_Pgto = 'B'
			and FC.status_pc = 'E'
		order by 1 
	end

Declare @Temp Table(
	JOB					varchar(17),
	PO					Varchar(200),
	MAWB				varchar(50),
	HAWB				varchar(50),
	[Taxa]				varchar(50),
	[Valor]				decimal(17,2)	
)

--declare @Num_Proc varchar(16)
--set @Num_Proc = 'IMSLA202102001BR'

insert into @Temp	
		select distinct
			FCHB.fatcod [Job], 
			null,
			null,
			null,
			null,  
			null
		from vwcta_Cte cx with(nolock)
			join vwFaturasValidasCHB FCHB with(nolock) on cx.Num_Proc_HIA = FCHB.Num_Proc AND cx.Cd_Tp_Tx = FCHB.Cd_Tp_Tx AND cx.DC_HIA=FCHB.DC
		where cx.Num_NF_HIA = '108802' and cx.Ref_Acesso_NF_HIA = 'I'

insert into @Temp	
		select 
			Temp.JOB [Job], 
			'PO ' + isnull(	dbo.[fBusca_Docs_PO_Modal](FCHB.Num_Proc,1),'') [PO],
			'MBL ' + isnull(A.MAWB,'')  MAWB,
			'HBL ' + isnull(A.HAWB,'')  HAWB,
			T.nome_tp_tx [Taxa],  
			--dbo.valor(cc.Vlr_Org_HIA ,cc.DC_HIA) [valor]
			--cc.Vlr_Org_HIA [valor]
			FCHB.Vlr_PC [valor]
		from @Temp Temp 
			join vwFaturasValidasCHB_Tp_Pgto FCHB with(nolock) on FCHB.fatcod = Temp.JOB and FCHB.tp_Pgto = 'B'		
			join Tipo_taxa T with(nolock) on T.cd_tp_tx = FCHB.cd_tp_tx and T.Nome_Tp_Tx not like 'Transf. Processo%'	
			join vwCliente_Alerta A with(nolock) on A.num_proc = FCHB.Num_Proc
	

insert into @Temp
	select distinct T.[Job], [PO],MAWB,HAWB,TT.nome_tp_tx [Taxa],
		dbo.valor(I.vlr_RS ,I.DC) [valor]
		from @Temp T 
		join FATURA_CHB FAT with(nolock) on Fat.Fatura_PC = T.[Job]
		join Item_Fat I with(nolock) on I.Fatcod = BDP_Invoice
		join Tipo_taxa	TT with(nolock) on TT.cd_tp_tx = I.cd_tp_tx
	

select distinct 'Job ' + [Job] [Job], [PO],MAWB,HAWB,[Taxa],[Valor] from @Temp where [PO] is not null order by 1



Declare @Temp Table(
	JOB					varchar(17),
	PO					Varchar(200),
	MAWB				varchar(50),
	HAWB				varchar(50),
	[Taxa]				varchar(50),
	[Valor]				decimal(17,2)	
)
--declare @Num_Proc varchar(16)
--set @Num_Proc = 'IMSLA202103001BR'

insert into @Temp	
		select 
			FCHB.fatcod [Job], 
			'PO ' + isnull(	dbo.[fBusca_Docs_PO_Modal](CX.Num_Proc_HIA,1),'') [PO],
			'MBL ' + isnull(A.MAWB,'')  MAWB,
			'HBL ' + isnull(A.HAWB,'')  HAWB,
			T.nome_tp_tx [Taxa],  
			--dbo.valor(cc.Vlr_Org_HIA ,cc.DC_HIA) [valor]
			--cc.Vlr_Org_HIA [valor]
			FCHB.Vlr_PC [valor]
		from vwCXAS cx with(nolock)
			join vwcta_Cte	cc  with(nolock) on cc.Num_Proc_HIA = cx.Num_Proc_HIA
			join Tipo_taxa	T with(nolock) on T.cd_tp_tx = cc.cd_tp_tx and T.Nome_Tp_Tx not like 'Transf. Processo%'	
			join vwFaturasValidasCHB FCHB with(nolock) on cc.Num_Proc_HIA = FCHB.Num_Proc AND cc.Cd_Tp_Tx = FCHB.Cd_Tp_Tx AND cc.DC_HIA=FCHB.DC
			join vwCliente_Alerta A with(nolock) on A.num_proc = CX.Num_Proc_HIA	
		where Num_Lcto in
		(select Distinct Num_Lcto from vwcta_Cte cc  with(nolock)
		join vwCXAS cx  with(nolock) on cc.Num_Proc_HIA = cx.Num_Proc_HIA 
		where cc.Num_Proc_HIA = @Num_Proc) and cx.Num_Proc_HIA <>@Num_Proc
		--and cx.num_proc_hia = 'IASLA202102002BR'
		--order by 1
	

insert into @Temp
	select distinct T.[Job], [PO],MAWB,HAWB,TT.nome_tp_tx [Taxa],
		dbo.valor(I.vlr_RS ,I.DC) [valor]
		from @Temp T 
		join FATURA_CHB FAT with(nolock) on Fat.Fatura_PC = T.[Job]
		join Item_Fat I with(nolock) on I.Fatcod = BDP_Invoice
		join Tipo_taxa	TT with(nolock) on TT.cd_tp_tx = I.cd_tp_tx
	

select distinct 'Job ' + [Job] [Job], [PO],MAWB,HAWB,[Taxa],[Valor] from @Temp order by 1




--declare @Num_Proc varchar(16)
--set @Num_Proc = 'IMSLA202103001BR'
select 
	'Job ' + FCHB.fatcod [Job], 
	'PO ' + isnull(	dbo.[fBusca_Docs_PO_Modal](CX.Num_Proc_HIA,1),'') [PO],
	'MBL ' + isnull(A.MAWB,'')  MAWB,
	'HBL ' + isnull(A.HAWB,'')  HAWB,
	T.nome_tp_tx [Taxa], 
	cc.Vlr_Org_HIA [valor]
	--,	FCHB.Vlr_PC [valor]
from vwCXAS cx with(nolock)
	join vwcta_Cte	cc  with(nolock) on cc.Num_Proc_HIA = cx.Num_Proc_HIA-- AND cc.Cd_Tp_Tx = cx.Cd_Tp_Tx AND CC.DC_HIA=CX.DC_HIA
	join Tipo_taxa	T with(nolock) on T.cd_tp_tx = cc.cd_tp_tx and T.Nome_Tp_Tx not like 'Transf. Processo%'
	--join vwFaturas_CHB_Validas FCHB with(nolock) on cx.Num_Proc_HIA = FCHB.Num_Proc AND cx.Cd_Tp_Tx = FCHB.Cd_Tp_Tx AND cx.DC_HIA=FCHB.DC
	join vwFaturasValidasCHB FCHB with(nolock) on cc.Num_Proc_HIA = FCHB.Num_Proc AND cc.Cd_Tp_Tx = FCHB.Cd_Tp_Tx AND cc.DC_HIA=FCHB.DC
	join vwCliente_Alerta A with(nolock) on A.num_proc = CX.Num_Proc_HIA	
where Num_Lcto in
(select Distinct Num_Lcto from vwcta_Cte cc  with(nolock)
join vwCXAS cx  with(nolock) on cc.Num_Proc_HIA = cx.Num_Proc_HIA 
where cc.Num_Proc_HIA = @Num_Proc) and cx.Num_Proc_HIA <>@Num_Proc
order by 1


select 
	Num_Lcto,
	Num_Proc_HIA [BDP Ref.], 
	dbo.[fBusca_Docs_PO_Modal](Num_Proc_HIA,1),
	dbo.[fBusca_Docs_PO_Modal](Num_Proc_HIA,9),	
	sum(dbo.valor(Vlr_Pgto_Rcto_HIA,DC_HIA)),
	NULL,
	NULL,
	dbo.[fBusca_Tarefa](Num_Proc_HIA,40),
	ISNULL(dbo.[fBusca_Docs_PO_Modal](Num_Proc_HIA,5),dbo.[fBusca_Docs_PO_Modal](Num_Proc_HIA,4)),
	dbo.[fBusca_Docs_PO_Modal](Num_Proc_HIA,2)	  
from
	 vwCXAS cx with(nolock)
where Num_Lcto in
(select Distinct Num_Lcto from vwcta_Cte cc  with(nolock)
join vwCXAS cx  with(nolock) on cc.Num_Proc_HIA = cx.Num_Proc_HIA 
where cc.Num_Proc_HIA = 'IMSLA202103001BR') and Num_Proc_HIA <>'IMSLA202103001BR'
group by Num_Proc_HIA,Num_Lcto

select * from vwCXAS where Num_Proc_HIA = 'IMSLA202103001BR'
(select Distinct Num_Lcto from vwcta_Cte cc  with(nolock)
join vwCXAS cx  with(nolock) on cc.Num_Proc_HIA = cx.Num_Proc_HIA 
where cc.Num_Proc_HIA = 'IMSLA202103001BR'

select * from vwCXAS where Num_Lcto in 
(select cx.Num_Lcto from vwcta_Cte cc  with(nolock)
join vwCXAS cx  with(nolock) on cc.Num_Proc_HIA = cx.Num_Proc_HIA 
where cc.Num_Proc_HIA = 'IMSLA202103001BR')
and Num_Proc_HIA <>'IMSLA202103001BR'


select * from vwcta_Cte cc  with(nolock)
join vwCXAS cx  with(nolock) on cc.Num_Proc_HIA = cx.Num_Proc_HIA 
where cc.Num_Proc_HIA = 'IMCTV202011113BR'


	select 
		'Job ' + F.fatura_cc [Job], 
		'PO ' + isnull(dbo.fBusca_TipoDocCliente('N',I.Num_Proc_HIA,3),'') [PO],
		'MBL ' + isnull(A.MAWB,'')  MAWB,
		'HBL ' + isnull(A.HAWB,'')  HAWB,
		T.nome_tp_tx [Taxa], 
		F.Vlr_PC [valor] 
	from vwcta_Cte I	
		join fatura_chb FC on FC.Processo_PC = I.Num_Proc_HIA
		join Fatura_CHB_Item F on FC.fatura_pc = F.fatura_cc
		join Tipo_taxa T on T.cd_tp_tx = F.cd_tp_tx and T.Nome_Tp_Tx not like 'Adianta%'
		join vwCliente_Alerta A on A.num_proc = I.Num_Proc_HIA
	where 
		--I.Num_NF_HIA = @Num_NF and I.Ref_Acesso_NF_HIA = @Ref_Acesso
		--and
		F.Tp_Pgto = 'B'
		and FC.status_pc = 'E'
	order by 1 


	ALTER Procedure [dbo].[spReportFaturamentoDetalhado_Rel]--'108802 ','I'
(
	@Num_Cpf_Cnpj	varchar(50),
	@Initial_Date	DateTime,
	@Final_Date		DateTime
)

as



--Declare @Num_Cpf_Cnpj	varchar(50)
--Declare @Initial_Date	DateTime
--Declare	@Final_Date		DateTime

--set @Num_Cpf_Cnpj = '60.435.351/0047-30'
--set @Initial_Date = '2021-07-19'
--set	@Final_Date	= '2021-07-25'

		select 
			'Job ' + F.fatura_cc [Job], 
			'PO ' + isnull(dbo.fBusca_TipoDocCliente('N',FC.Processo_PC,3),'') [PO],			
			'MBL ' + isnull(A.MAWB,'')  MAWB,
			'HBL ' + isnull(A.HAWB,'')  HAWB,	
			T.nome_tp_tx [Taxa], 
			F.Vlr_PC [valor],
			FC.Data_PC DataPC
		from fatura_chb FC
			join Pessoa P on P.cd_pes = FC.cd_pes_pc
			join Fatura_CHB_Item F on FC.fatura_pc = F.fatura_cc
			join Tipo_taxa T on T.cd_tp_tx = F.cd_tp_tx and T.Nome_Tp_Tx not like 'Adianta%'
			left join vwCliente_Alerta A on A.num_proc = FC.Processo_PC	
		where 
			P.num_cpf_cnpj = replace(replace(replace(@Num_Cpf_Cnpj,'.',''),'-',''),'/','')
			and FC.Data_PC between @Initial_Date and @Final_Date
			and	F.Tp_Pgto = 'B'
			and FC.status_pc = 'E'
			and FC.Processo_PC not like 'BO%'

		UNION ALL

		select 
			'Job ' + F.fatura_cc [Job], 			
			'PO ' + isnull(dbo.fBusca_TipoDocCliente('N',BO.Num_Proc,3),'') [PO],
			'MBL ' + isnull(A.MAWB,'')  MAWB,
			'HBL ' + isnull(A.HAWB,'')  HAWB,
			T.nome_tp_tx [Taxa], 
			F.Vlr_PC [valor],
			FC.Data_PC DataPC
		from fatura_chb FC
			join Pessoa P on P.cd_pes = FC.cd_pes_pc
			join Fatura_CHB_Item F on FC.fatura_pc = F.fatura_cc
			join Tipo_taxa T on T.cd_tp_tx = F.cd_tp_tx and T.Nome_Tp_Tx not like 'Adianta%'
			join JOB_HBO BO on BO.num_proc_HBO = FC.Processo_PC		
			left join vwCliente_Alerta A on A.num_proc = BO.Num_Proc
		where 
			P.num_cpf_cnpj = replace(replace(replace(@Num_Cpf_Cnpj,'.',''),'-',''),'/','')
			and FC.Data_PC between @Initial_Date and @Final_Date
			and	F.Tp_Pgto = 'B'
			and FC.status_pc = 'E'
			and FC.Processo_PC  like 'BO%'
		order by 7 


		

--select * from vwcta_cte where num_proc_hia ='EACSR202107001BR' and num_nf_hia = '108802'
--select * from fatura_chb where Processo_PC like '%IMCSR202105324BR%'
--select * from vwFaturasValidasCHB where Num_Proc like '%IMCSR202105324BR%'

--NFe 108795 
--RPS 108802 
--Filial Santos
--Total que deve aparecer no Report R$ 41.722,20

--select *from vwFaturasValidasCHB_Tp_Pgto F
--	join tipo_taxa t on t.cd_tp_tx = F.cd_tp_tx
--where Num_Proc='IMCSR202105324BR' and tp_Pgto = 'B'		

--[spReportFaturamentoDetalhado_Rel] 'IOSWB202102006BR'
-- and fc.cd_tipo = 'P' para só trazer a principal

--select * from vwPO_ALL where id_dc = 25 and num_proc like '%csr%'
--select * from Tipo_Doc_Cliente where id_dc = 25 
--[spReportFaturamentoDetalhado_Rel]'ADTO BDP 5','I'
--[spReportFaturamentoDetalhado_Rel]'108802 ','I'

--select * from JOB_HBO where num_proc_Hbo = 'BOCSR202102036BR'
--select * from House_BDP_OUT where num_proc_Hbo = 'BOCSR202102036BR'
--select * from LLP_BDP_OUT where num_proc_lbo = 'BOCSR202102036BR'

--select * from pessoa where cd_pes = 'P000015513'
--Declare @cd_pes as varchar(10)
--set @cd_pes = (select cd_pes from Pessoa where num_cpf_cnpj = replace(replace(replace('60.435.351/0003-19','.',''),'-',''),'/',''))

--select * from fatura_chb FC
--			join Pessoa P on P.cd_pes = FC.cd_pes_pc
--where 
--P.num_cpf_cnpj = replace(replace(replace('60.435.351/0003-19','.',''),'-',''),'/','')
--and 
--FC.data_pc > getdate() -90
--and FC.Processo_PC  like 'BO%'	

--spReportFaturamentoDetalhado_CNPJ_Sel

--2021-06-15 00:00:00
--60.435.351/0003-19

*/


















GO
