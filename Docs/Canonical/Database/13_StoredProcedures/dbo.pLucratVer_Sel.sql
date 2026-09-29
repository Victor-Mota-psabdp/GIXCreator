SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pLucratVer_Sel 
(
@Data1		DateTime, 
@Data2		DateTime 
)
AS

		Select 
			Distinct Cte.Cd_Tp_Moeda  as  Moeda
		From 
			House_Imp_Mar as HIM Join Cta_Cte_Hou_Imp_Mar as Cte on Cte.Num_Proc_HIM = HIM.Num_Proc_HIM 
		Where 
			Convert(Datetime, HIM.Dt_Emis_HIM, 105) between @Data1 and @Data2 
			and Cte.Cd_Tp_Moeda Not In (Select Cd_Tp_Moeda From Paridade Where Cd_Tp_Par = 'OFC' and Dt_Par = dbo.StrHoje(GetDate()))

		Union

		Select 
			Distinct Cte.Cd_Tp_Moeda 
		From 
			House_Imp_Aer as HIA Join Cta_Cte_Hou_Imp_Aer as Cte on Cte.Num_Proc_HIA = HIA.Num_Proc_HIA
		Where 
			Convert(Datetime, HIA.Dt_Emis_HIA, 105) between @Data1 and @Data2 
			and Cte.Cd_Tp_Moeda Not In (Select Cd_Tp_Moeda From Paridade Where Cd_Tp_Par = 'OFC' and Dt_Par = dbo.StrHoje(GetDate()))

		Union

		Select 
			Distinct Cte.Cd_Tp_Moeda 
		From 
			House_Exp_Mar as HEM Join Cta_Cte_Hou_Exp_Mar as Cte on Cte.Num_Proc_HEM = HEM.Num_Proc_HEM
		Where 
			Convert(Datetime, HEM.Dt_Emis_HEM, 105) between @Data1 and @Data2 
			and Cte.Cd_Tp_Moeda Not In (Select Cd_Tp_Moeda From Paridade Where Cd_Tp_Par = 'OFC' and Dt_Par = dbo.StrHoje(GetDate()))


		Union

		Select 
			Distinct Cte.Cd_Tp_Moeda 
		From 
			House_Exp_Aer as HEA Join Cta_Cte_Hou_Exp_Aer as Cte on Cte.Num_Proc_HEA = HEA.Num_Proc_HEA
		Where 
			Convert(Datetime, HEA.Dt_Emis_HEA, 105) between @Data1 and @Data2 
			and Cte.Cd_Tp_Moeda Not In (Select Cd_Tp_Moeda From Paridade Where Cd_Tp_Par = 'OFC' and Dt_Par = dbo.StrHoje(GetDate()))

		Union 

		Select 
			Distinct Cte.Cd_Tp_Moeda 
		From 
			Master_Imp_Mar as MIM Join Cta_Cte_Mas_Imp_Mar as Cte on Cte.Num_Proc_MIM = MIM.Num_Proc_MIM 
		Where 
			MIM.Num_Proc_MIM in (	Select Distinct Cte.Cd_Tp_Moeda From House_Imp_Mar as HIM Where Convert(Datetime, HIM.Dt_Emis_HIM, 105) between @Data1 and @Data2 )

		Union

		Select 
			Distinct Cte.Cd_Tp_Moeda 
		From 
			Master_Imp_Aer as MIA Join Cta_Cte_Mas_Imp_Aer as Cte on Cte.Num_Proc_MIA = MIA.Num_Proc_MIA
		Where 
			MIA.Num_Proc_MIA in (	Select Distinct Cte.Cd_Tp_Moeda From House_Imp_Aer as HIA Where Convert(Datetime, HIA.Dt_Emis_HIA, 105) between @Data1 and @Data2 )

		Union

		Select 
			Distinct Cte.Cd_Tp_Moeda 
		From 
			Master_Exp_Mar as MEM Join Cta_Cte_Mas_Exp_Mar as Cte on Cte.Num_Proc_MEM = MEM.Num_Proc_MEM
		Where 
			MEM.Num_Proc_MEM in (Select Distinct Cte.Cd_Tp_Moeda From House_Exp_Mar as HEM Where Convert(Datetime, HEM.Dt_Emis_HEM, 105) between @Data1 and @Data2 )


		Union

		Select 
			Distinct Cte.Cd_Tp_Moeda 
		From 
			Master_Exp_Aer as MEA Join Cta_Cte_Mas_Exp_Aer as Cte on Cte.Num_Proc_MEA = MEA.Num_Proc_MEA
		Where 
			MEA.Num_Proc_MEA in (Select Distinct Cte.Cd_Tp_Moeda From House_Exp_Aer as HEA Where Convert(Datetime, HEA.Dt_Emis_HEA, 105) between @Data1 and @Data2 )

GO
