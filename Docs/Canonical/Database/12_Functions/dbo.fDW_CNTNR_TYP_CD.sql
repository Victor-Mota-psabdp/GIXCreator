SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fDW_CNTNR_TYP_CD]
(
	@Num_Proc Varchar(16),
	@Line int
)

returns varchar(25)

AS 

BEGIN
	Declare @Valor varchar(25)
	SET @Valor = ''

	if LEFT(@NUM_PROC,2)='EM'
		BEGIN
			set @valor=(
				SELECT cd_smart
				FROM (
					select ROW_NUMBER() OVER(ORDER BY Mas.num_cont_em ASC) AS Row#,tc.cd_smart from Container_Mas_Exp_Mar MAS with(nolock)
					join Container_Hou_Exp_Mar HOU with(nolock) on HOU.Item_Cont_EM = MAS.Item_Cont_EM and MAS.Num_Proc_MEM = HOU.Num_Proc_MEM
					Join Tipo_Container TC on tC.cd_tp_cont=MAS.cd_tp_cont
					where HOU.Num_Proc_HEM = @Num_Proc and LEFT(NUM_CONT_EM,1)<>'_'
					) AS Subquery
				WHERE 
					Row# = @Line
				)
		END
	ELSE
		BEGIN
			set @valor=(
				SELECT cd_smart
				FROM (
					select ROW_NUMBER() OVER(ORDER BY Mas.num_cont_im ASC) AS Row#,tc.cd_smart from Container_Mas_Imp_Mar MAS with(nolock)
					join Container_Hou_Imp_Mar HOU with(nolock) on HOU.Item_Cont_IM = MAS.Item_Cont_IM and MAS.Num_Proc_MIM = HOU.Num_Proc_MIM
					Join Tipo_Container TC on tC.cd_tp_cont=MAS.cd_tp_cont
					where HOU.num_proc_him = @Num_Proc and LEFT(Num_Cont_IM,1)<>'_'
					) AS Subquery
				WHERE 
					Row# = @Line
				)
		END
		
	return @Valor
END


GO
