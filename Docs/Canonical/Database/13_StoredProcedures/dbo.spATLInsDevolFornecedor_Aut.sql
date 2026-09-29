SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spATLInsDevolFornecedor_Aut

-- Rotina responsavel por gerar o lançamento do BDPCharges para Devolução de Adto. Fornecedor


AS



Declare		@Num_Proc		Varchar(16)
Declare		@Cd_Tp_Tx		Varchar(3)
Declare		@DC				Char(1)
Declare		@Org_Ins		VarChar(9)
Declare		@Dt_Ins			Char(10)
Declare		@Cd_Tp_Moeda	Varchar(3)
Declare		@Vlr_Org		Decimal(10,2)
Declare		@Dt_Prev_Pgto	VarChar(10)
Declare		@Cd_Cred_Dev	VarChar(10)
Declare		@Desp_Org		Char(1)
Declare		@CPMF			Char(1)
Declare		@Comp_RP		Char(1)
Declare		@Comp_DN		Char(1)---
Declare		@Comp_CN		Char(1)
Declare		@Comp_CPA		Char(1)
Declare		@Num_DCN		VarChar(9)
Declare		@Dt_Ctb_CC		VarChar(10)
Declare		@Num_NF			Varchar(12)
Declare		@Ref_Acesso_NF	Varchar(1)
Declare		@Vlr_Pgto_NF	Decimal(10,2)
Declare		@Par_NF			float
Declare		@Comp_Job		Char(1)
Declare		@Contab			bit
Declare		@Vlr_Contab		Decimal(10,2)
Declare		@Contab_Ant		bit
Declare		@Vlr_Contab_Ant Decimal(10,2)
Declare		@Contab_Mes_Ano	Varchar(7)
Declare		@Val_Con_Comp	Decimal(10,2)


Declare cTemp Cursor For
	select 
		cta.num_proc_hia,'XY0','C','ATL',Cta.Dt_Ins_HIa,cta.cd_Tp_moeda,cta.Vlr_Org_Hia,convert(varchar(10),convert(datetime,cta.dt_ins_hia,105)+40,103),
		cta.cd_cred_Dev_hia,'N','N','N','N','N','N',Null,Null,Null,Null,Null,Null,0,0,Null,0,Null,null,null
	
	from vwCTA_Cte cta
	JOIN Pessoa PP on pp.cd_pes=cd_cred_Dev_hia
	Join Tipo_Taxa TT on tt.cd_tp_Tx=cta.cd_tp_Tx
	Left Join vwcta_Cte cto on cta.num_proc_hia=cto.num_proc_hia and cto.dc_hia='C' and cto.cd_tp_Tx in ('DNF','XY0','XVL')
	Where 
		--apelido like '%Pibernat%'	and 
		cta.dc_hia='D' and cta.cd_tp_tx='DS5'
		and cto.num_proc_hia is null

open cTemp

			Fetch Next From cTemp Into @Num_Proc,	@Cd_Tp_Tx,	@DC,	@Org_Ins,	@Dt_Ins,	@Cd_Tp_Moeda,	@Vlr_Org,	@Dt_Prev_Pgto,	@Cd_Cred_Dev,	@Desp_Org,	@CPMF,	@Comp_RP,	@Comp_DN,	@Comp_CN,	@Comp_CPA,	@Num_DCN,	@Dt_Ctb_CC,	@Num_NF,	@Ref_Acesso_NF,	@Vlr_Pgto_NF,	@Par_NF,	@Comp_Job,	@Contab,	@Vlr_Contab,	@Contab_Ant,	@Vlr_Contab_Ant ,	@Contab_Mes_Ano,	@Val_Con_Comp

			While @@FETCH_STATUS = 0
				Begin 
					print @num_proc
					exec spCtaCte_InsUpd @Num_Proc,	@Cd_Tp_Tx,	@DC,	@Org_Ins,	@Dt_Ins,	@Cd_Tp_Moeda,	@Vlr_Org,	@Dt_Prev_Pgto,	@Cd_Cred_Dev,	@Desp_Org,	@CPMF,	@Comp_RP,	@Comp_DN,	@Comp_CN,	@Comp_CPA,	@Num_DCN,	@Dt_Ctb_CC,	@Num_NF,	@Ref_Acesso_NF,	@Vlr_Pgto_NF,	@Par_NF,	@Comp_Job,	@Contab,	@Vlr_Contab,	@Contab_Ant,	@Vlr_Contab_Ant ,	@Contab_Mes_Ano,	@Val_Con_Comp
					
					--exec spATLSimulaRent_Sel @Num_Proc

					--exec	spInsTempResultado @Num_Proc
					Fetch Next From cTemp Into @Num_Proc,	@Cd_Tp_Tx,	@DC,	@Org_Ins,	@Dt_Ins,	@Cd_Tp_Moeda,	@Vlr_Org,	@Dt_Prev_Pgto,	@Cd_Cred_Dev,	@Desp_Org,	@CPMF,	@Comp_RP,	@Comp_DN,	@Comp_CN,	@Comp_CPA,	@Num_DCN,	@Dt_Ctb_CC,	@Num_NF,	@Ref_Acesso_NF,	@Vlr_Pgto_NF,	@Par_NF,	@Comp_Job,	@Contab,	@Vlr_Contab,	@Contab_Ant,	@Vlr_Contab_Ant ,	@Contab_Mes_Ano,	@Val_Con_Comp
				End




GO
