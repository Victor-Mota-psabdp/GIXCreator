SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pRel36_sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pRel36_sel 
(
@tprel			varchar(2),
@cdcreddev		varchar(10) = "",
@dtins			datetime
)
AS
IF @tprel = "38"
   BEGIN
      IF @cdcreddev = ""
         SELECT DISTINCT Dt_Ins_MEA,
         Apelido, Cta_Cte_Mas_Exp_Aer.Num_Proc_MEA,
         Cta_Cte_Mas_Exp_Aer.Cd_Tp_Tx,  Cta_Cte_Mas_Exp_Aer.Cd_Tp_Moeda AS
         ACd_Tp_Moeda, DC_MEA, Vlr_Org_MEA FROM Cta_Cte_Mas_Exp_Aer,
         Master_Exp_Aer, Tipo_Taxa, Pessoa WHERE
         Cta_Cte_Mas_Exp_Aer.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx AND
         Desp_Dst_MEA = 'N' AND Cd_Cred_Dev_MEA <> '00' AND
         Cd_Cred_Dev_MEA <> '000' AND Cd_Cred_Dev_MEA = Cd_Pes AND
         Cast(Dt_Ins_MEA AS datetime) <= @dtins
      ELSE
         SELECT DISTINCT Dt_Ins_MEA, Apelido,
         Cta_Cte_Mas_Exp_Aer.Num_Proc_MEA, Cta_Cte_Mas_Exp_Aer.Cd_Tp_Tx,
         Cta_Cte_Mas_Exp_Aer.Cd_Tp_Moeda AS ACd_Tp_Moeda, DC_MEA,
         Vlr_Org_MEA FROM Cta_Cte_Mas_Exp_Aer, Master_Exp_Aer, Tipo_Taxa,
         Pessoa WHERE Cta_Cte_Mas_Exp_Aer.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx
         AND Desp_Dst_MEA = 'N' AND Cd_Cred_Dev_MEA <> '00' AND
         Cd_Cred_Dev_MEA <> '000' AND Cd_Cred_Dev_MEA = Cd_Pes AND
         Cd_Cred_Dev_MEA = @cdcreddev AND
         Cast(Dt_Ins_MEA AS datetime) <= @dtins
   END
ELSE
   BEGIN
      IF @tprel = "36"
         BEGIN
            IF @cdcreddev = ""
               SELECT DISTINCT Dt_Ins_MEA,
               Apelido, Cta_Cte_Mas_Exp_Aer.Num_Proc_MEA,
               Cta_Cte_Mas_Exp_Aer.Cd_Tp_Tx,  Cta_Cte_Mas_Exp_Aer.Cd_Tp_Moeda
               AS ACd_Tp_Moeda, DC_MEA, Vlr_Org_MEA FROM
               Cta_Cte_Mas_Exp_Aer, Master_Exp_Aer, Tipo_Taxa, Pessoa WHERE
               Cta_Cte_Mas_Exp_Aer.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx AND
               Desp_Dst_MEA = 'N' AND Cd_Cred_Dev_MEA <> '00' AND
               Cd_Cred_Dev_MEA <> '000' AND Cd_Tp_Ativ = "AGT" AND
               Cd_Cred_Dev_MEA = Cd_Pes AND
               Cast(Dt_Ins_MEA AS datetime) <= @dtins
            ELSE
               SELECT DISTINCT Dt_Ins_MEA, Apelido,
               Cta_Cte_Mas_Exp_Aer.Num_Proc_MEA,
               Cta_Cte_Mas_Exp_Aer.Cd_Tp_Tx, Cta_Cte_Mas_Exp_Aer.Cd_Tp_Moeda
               AS ACd_Tp_Moeda, DC_MEA, Vlr_Org_MEA FROM
               Cta_Cte_Mas_Exp_Aer, Master_Exp_Aer, Tipo_Taxa, Pessoa WHERE
               Cta_Cte_Mas_Exp_Aer.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx AND
               Desp_Dst_MEA = 'N' AND Cd_Cred_Dev_MEA <> '00' AND
               Cd_Cred_Dev_MEA <> '000' AND Cd_Tp_Ativ = "AGT" AND
               Cd_Cred_Dev_MEA = Cd_Pes AND Cd_Cred_Dev_MEA = @cdcreddev
               AND Cast(Dt_Ins_MEA AS datetime) <= @dtins
         END
      ELSE
         BEGIN
            IF @cdcreddev = ""
               SELECT DISTINCT Dt_Ins_MEA,
               Apelido, Cta_Cte_Mas_Exp_Aer.Num_Proc_MEA,
               Cta_Cte_Mas_Exp_Aer.Cd_Tp_Tx,  Cta_Cte_Mas_Exp_Aer.Cd_Tp_Moeda
               AS ACd_Tp_Moeda, DC_MEA, Vlr_Org_MEA FROM
               Cta_Cte_Mas_Exp_Aer, Master_Exp_Aer, Tipo_Taxa, Pessoa WHERE
               Cta_Cte_Mas_Exp_Aer.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx AND
               Desp_Dst_MEA = 'N' AND Cd_Cred_Dev_MEA <> '00' AND
               Cd_Cred_Dev_MEA <> '000' AND Cd_Tp_Ativ <> "AGT" AND
               Cd_Cred_Dev_MEA = Cd_Pes AND
               Cast(Dt_Ins_MEA AS datetime) <= @dtins
            ELSE
               SELECT DISTINCT Dt_Ins_MEA, Apelido,
               Cta_Cte_Mas_Exp_Aer.Num_Proc_MEA,
               Cta_Cte_Mas_Exp_Aer.Cd_Tp_Tx, Cta_Cte_Mas_Exp_Aer.Cd_Tp_Moeda
               AS ACd_Tp_Moeda, DC_MEA, Vlr_Org_MEA FROM
               Cta_Cte_Mas_Exp_Aer, Master_Exp_Aer, Tipo_Taxa, Pessoa WHERE
               Cta_Cte_Mas_Exp_Aer.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx AND
               Desp_Dst_MEA = 'N' AND Cd_Cred_Dev_MEA <> '00' AND
               Cd_Cred_Dev_MEA <> '000' AND Cd_Tp_Ativ <> "AGT" AND
               Cd_Cred_Dev_MEA = Cd_Pes AND Cd_Cred_Dev_MEA = @cdcreddev
               AND Cast(Dt_Ins_MEA AS datetime) <= @dtins
         END
   END



GO
