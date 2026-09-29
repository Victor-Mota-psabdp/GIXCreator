SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE  pAuditor_Rel
(
@StrMachine	Varchar(20)
)
 AS
	Select *, valor_c = case when tmpdc = 'C' then tmpvalor else 0 end, valor_d = case when tmpdc = 'D' then tmpvalor else 0 end   from tmp_auditor ta join tipo_taxa tt on tt.cd_tp_Tx = ta.tmpcd_tp_Tx Where tmpmachine = @Strmachine and tmpprocesso in 
		(select distinct tmpprocesso from tmp_auditor_MSG where tmpmachine = @Strmachine )
		Order by tmpprocesso, tmpcd_tp_Tx


GO
