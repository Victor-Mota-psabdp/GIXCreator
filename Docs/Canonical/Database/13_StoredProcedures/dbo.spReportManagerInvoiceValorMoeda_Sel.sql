SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spReportManagerInvoiceValorMoeda_Sel]--[spReportManagerInvoiceValorMoeda_Sel]  'EMCSR201310052BR','',0,''

	@Num_Proc varchar(16),
	@Cd_Moeda_Invoice Varchar(3) output,
	@Vlr_Invoice Varchar(40) output,
	@Moeda_Valor Varchar(40) output
as

if lefT(@Num_Proc,2)='EM'
	Begin
		select @Cd_Moeda_Invoice = Cd_Moeda_Invoice ,@Vlr_Invoice = Vlr_Invoice, @Vlr_Invoice = cast(cast(vlr_Invoice as Decimal(18,2)) as varchar(25))  , @Moeda_Valor= cd_Moeda_Invoice +' ' + cast(cast(vlr_Invoice as Decimal(18,2)) as varchar(25))     from llp_exp_mar where num_proc_lem=@Num_Proc
	End


if lefT(@Num_Proc,2)='EA'
	Begin
		select @Cd_Moeda_Invoice = Cd_Moeda_Invoice ,@Vlr_Invoice = cast(cast(vlr_Invoice as Decimal(18,2)) as varchar(25))  , @Moeda_Valor= cd_Moeda_Invoice +' ' + cast(cast(vlr_Invoice as Decimal(18,2)) as varchar(25))     from llp_exp_aer where num_proc_lea=@Num_Proc
	End


if lefT(@Num_Proc,2)='EO'
	Begin
		select 
			@Cd_Moeda_Invoice = Cd_Moeda_Invoice ,
			@Vlr_Invoice = cast(cast(vlr_Invoice as Decimal(18,2)) as varchar(25))
			,@Moeda_Valor= cd_Moeda_Invoice +' ' + cast(cast(vlr_Invoice as Decimal(18,2)) as varchar(25))   
		from 
			llp_exp_out 
		where 
			num_proc_leo=@Num_Proc
	End

if lefT(@Num_Proc,2)='IM'
	Begin
		select 
			@Cd_Moeda_Invoice = Cd_Moeda_Invoice ,@Vlr_Invoice = cast(cast(vlr_Invoice as Decimal(18,2)) as varchar(25))  , @Moeda_Valor= cd_Moeda_Invoice +' ' + cast(cast(vlr_Invoice as Decimal(18,2)) as varchar(25))   
		from llp_imp_mar where num_proc_lim=@Num_Proc
	End

if lefT(@Num_Proc,2)='IA'
	Begin
		select 
			@Cd_Moeda_Invoice = Cd_Moeda_Invoice ,@Vlr_Invoice = cast(cast(vlr_Invoice as Decimal(18,2)) as varchar(25)), @Moeda_Valor= cd_Moeda_Invoice +' ' + cast(cast(vlr_Invoice as Decimal(18,2)) as varchar(25))   
		from llp_imp_aer where num_proc_lia=@Num_Proc
	End

if lefT(@Num_Proc,2)='IO'
	Begin
		select 

			@Cd_Moeda_Invoice = Cd_Moeda_Invoice ,@Vlr_Invoice = cast(cast(vlr_Invoice as Decimal(18,2)) as varchar(25)), @Moeda_Valor= cd_Moeda_Invoice +' ' + cast(cast(vlr_Invoice as Decimal(18,2)) as varchar(25))

		from llp_imp_out where num_proc_lio=@Num_Proc
	End
/*
print @Vlr_Invoice
Set @Vlr_Invoice = cast(cast(Replace(@Vlr_Invoice,',','.') as Decimal(18,2)) as varchar(25))
Set @Moeda_Valor = Replace(@Moeda_Valor,',','.')
*/
print @Vlr_Invoice
print @Moeda_Valor

GO
