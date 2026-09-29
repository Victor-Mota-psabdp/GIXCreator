SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spContainerMaster_Sel]--'EMOXT20101103801'
	@Processo	varchar(16)
as

if left(@processo,2) = 'EM'
	Begin
		select distinct 
			Num_cont_EM, 
			nome_tp_cont, 
			Num_Lacre_EM, 
			Lacre_02_EM 
		from Container_Mas_Exp_Mar MAS
		Join Tipo_Container TC on TC.cd_tp_cont=MAS.cd_tp_cont
		where Num_Proc_MEM =@Processo
	End
else	
	Begin
		select distinct 
			Num_cont_IM, 
			nome_tp_cont, 
			Num_Lacre_IM,
			Lacre_02_IM 
		from Container_Mas_Imp_Mar MAS
             Join Tipo_Container TC on TC.cd_tp_cont=MAS.cd_tp_cont
             where Num_Proc_MIM =@Processo
	End
			
	
GO
