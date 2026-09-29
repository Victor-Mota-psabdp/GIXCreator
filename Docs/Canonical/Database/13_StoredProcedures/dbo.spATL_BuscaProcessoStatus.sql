SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_BuscaProcessoStatus] --9
 @ID_Status int
as

select Num_proc_lim Processo from LLP_Imp_MAr
where ID_Status = @ID_Status and substring(Num_proc_Lim,6,4) in ('2014' ,'2015') --and SUBSTRING(Num_Proc_Lim,3,3) = 'LVS'
Union ALL
select Num_proc_lia from LLP_Imp_aer
where ID_Status = @ID_Status and substring(Num_proc_Lia,6,4) in ('2014' ,'2015') --and SUBSTRING(Num_Proc_Lia,3,3) = 'LVS'
Union ALL
select Num_proc_lio from LLP_Imp_out
where ID_Status = @ID_Status and substring(Num_proc_Lio,6,4) in ('2014' ,'2015') --and SUBSTRING(Num_Proc_Lio,3,3) = 'LVS'
Union ALL
select Num_proc_lem from LLP_exp_mar
where ID_Status = @ID_Status and substring(Num_proc_Lem,6,4) in ('2014' ,'2015') --and SUBSTRING(Num_Proc_Lem,3,3) = 'LVS'
Union ALL
select Num_proc_lea from LLP_exp_aer
where ID_Status = @ID_Status and substring(Num_proc_Lea,6,4) in ('2014' ,'2015') --and SUBSTRING(Num_Proc_Lea,3,3) = 'LVS'
Union ALL
select Num_proc_leo Processo from LLP_exp_out
where ID_Status = @ID_Status and substring(Num_proc_Leo,6,4) in ('2014' ,'2015')--and Num_proc_leo in ('EORHO201403001BR','EOATL201403003BR')
GO
