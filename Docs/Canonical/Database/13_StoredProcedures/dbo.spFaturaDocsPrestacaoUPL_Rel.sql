SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from po_him where num_proc_him = 'IMUPL201206001BR'
--por solicitação do cliente , não aparece o customer po no referencias e sim na Referencia UPL
CREATE Procedure [dbo].[spFaturaDocsPrestacaoUPL_Rel]-- 'IMUPL201206001BR'

@Fatura varchar(17)

As

	if len(@fatura) >= 16
		BEGIN
			select
				TDC.Nome_DC,
				isnull(BO.Numero_PO_HBO,isnull(EA.Numero_PO_HEA,isnull(EM.Numero_PO_HEM,isnull(EO.Numero_PO_HEO,isnull(IA.Numero_PO_HIA,isnull(IM.Numero_PO_HIM,isnull(PIO.Numero_PO_HIO,MAS.Numero_PO))))))) Num_Doc,
				IM.Data_PO_HIM Data_Doc,
				(case
					when Tipo = 'C' then 'Cópia' 
					when Tipo = 'O' then 'Original' 
					when Tipo = 'A' then 'Original e Cópia' 
				end) Anexo
			from
				Fatura_Docs FD
				Left Join Tipo_Doc_Cliente TDC on TDC.ID_DC = FD.ID_DC
				Left Join PO_HEA EA  on EA.Num_Proc_HEA=left(@Fatura,16) and EA.ID_DC = FD.ID_DC and EA.id_dc <> 9
				Left Join PO_HEM EM  on EM.Num_Proc_HEM=left(@Fatura,16) and EM.ID_DC = FD.ID_DC and EM.id_dc <> 9
				Left Join PO_HEO EO  on EO.Num_Proc_HEO=left(@Fatura,16) and EO.ID_DC = FD.ID_DC and EO.id_dc <> 9
				Left Join PO_HIA IA  on IA.Num_Proc_HIA=left(@Fatura,16) and IA.ID_DC = FD.ID_DC and IA.id_dc <> 9
				Left Join PO_HIM IM  on IM.Num_Proc_HIM=left(@Fatura,16) and IM.ID_DC = FD.ID_DC and IM.id_dc <> 9
				Left Join PO_HIO PIO on PIO.Num_Proc_HIO=left(@Fatura,16) and PIO.ID_DC = FD.ID_DC and PIO.id_dc <> 9
				Left Join PO_HBO BO on BO.Num_Proc_HBO=left(@Fatura,16) and BO.ID_DC = FD.ID_DC and BO.id_dc <> 9
				Left Join PO_Master MAS on MAS.Num_Proc_Master=left(@Fatura,14) and MAS.ID_DC = FD.ID_DC and MAS.ID_DC <> 9
			where
				Fatura_PC=@Fatura

		UNION
			select  
				TDC.Nome_DC, EA.Numero_PO_HEA Num_Doc, EA.Data_PO_HEA Data_Doc, '-' Anexo
			from 
				PO_HEA EA
				Join Tipo_Doc_Cliente TDC on TDC.ID_DC=EA.ID_DC and EA.ID_DC <> 9
			where 
				Num_Proc_HEA=left(@Fatura,16) and EA.ID_DC not in 
				(select ID_DC from Fatura_Docs where Fatura_PC=@Fatura)

		UNION
			select  
				TDC.Nome_DC, EM.Numero_PO_HEM Num_Doc, EM.Data_PO_HEM Data_Doc, '-' Anexo
			from 
				PO_HEM EM
				Join Tipo_Doc_Cliente TDC on TDC.ID_DC=EM.ID_DC and EM.ID_DC <> 9
			where 
				Num_Proc_HEM=left(@Fatura,16) and EM.ID_DC not in 
				(select ID_DC from Fatura_Docs where Fatura_PC=@Fatura)

		UNION
			select  
				TDC.Nome_DC, EO.Numero_PO_HEO Num_Doc, EO.Data_PO_HEO Data_Doc, '-' Anexo
			from 
				PO_HEO EO
				Join Tipo_Doc_Cliente TDC on TDC.ID_DC=EO.ID_DC and EO.ID_DC <> 9
			where 
				Num_Proc_HEO=left(@Fatura,16) and EO.ID_DC not in 
				(select ID_DC from Fatura_Docs where Fatura_PC=@Fatura)
				
		UNION
			select  
				TDC.Nome_DC, EO.Numero_PO_HBO Num_Doc, EO.Data_PO_HBO Data_Doc, '-' Anexo
			from 
				PO_HBO EO
				Join Tipo_Doc_Cliente TDC on TDC.ID_DC=EO.ID_DC and EO.ID_DC <> 9
			where 
				Num_Proc_HBO=left(@Fatura,16) and EO.ID_DC not in 
				(select ID_DC from Fatura_Docs where Fatura_PC=@Fatura)

		UNION
			select  
				TDC.Nome_DC, IA.Numero_PO_HIA Num_Doc, IA.Data_PO_HIA Data_Doc, '-' Anexo
			from 
				PO_HIA IA
				Join Tipo_Doc_Cliente TDC on TDC.ID_DC=IA.ID_DC and IA.ID_DC <> 9
			where 
				Num_Proc_HIA=left(@Fatura,16) and IA.ID_DC not in 
				(select ID_DC from Fatura_Docs where Fatura_PC=@Fatura)

		UNION
			select  
				TDC.Nome_DC, IM.Numero_PO_HIM Num_Doc, IM.Data_PO_HIM Data_Doc, '-' Anexo
			from 
				PO_HIM IM
				Join Tipo_Doc_Cliente TDC on TDC.ID_DC=IM.ID_DC and IM.ID_DC <> 9
			where 
				Num_Proc_HIM=left(@Fatura,16) and IM.ID_DC not in 
				(select ID_DC from Fatura_Docs where Fatura_PC=@Fatura)

		UNION
			select  
				TDC.Nome_DC, IO.Numero_PO_HIO Num_Doc, IO.Data_PO_HIO Data_Doc, '-' Anexo
			from 
				PO_HIO IO
				Join Tipo_Doc_Cliente TDC on TDC.ID_DC=IO.ID_DC and IO.ID_DC <> 9
			where 
				Num_Proc_HIO=left(@Fatura,16) and IO.ID_DC not in 
				(select ID_DC from Fatura_Docs where Fatura_PC=@Fatura)
--		UNION
--			select  
--				TDC.Nome_DC, MAS.Numero_PO Num_Doc, MAS.Data_PO Data_Doc, '-' Anexo
--			from 
--				PO_Master MAS
--				Join Tipo_Doc_Cliente TDC on TDC.ID_DC=MAS.ID_DC
--			where 
--				MAS.Num_Proc_Master=left(@Fatura,14) and MAS.ID_DC not in 
--				(select ID_DC from Fatura_Docs where Fatura_PC=@Fatura)
		order by
			Data_Doc desc,
			Anexo,
			TDC.Nome_DC
	END
else
	Begin
		select
				TDC.Nome_DC,
				MAS.Numero_PO Num_Doc,
				MAS.Data_PO Data_Doc,
				(case
					when Tipo = 'C' then 'Cópia' 
					when Tipo = 'O' then 'Original' 
					when Tipo = 'A' then 'Original e Cópia' 
				end) Anexo
			from
				Fatura_Docs FD
				Left Join Tipo_Doc_Cliente TDC on TDC.ID_DC = FD.ID_DC
--				Left Join PO_HEA EA  on EA.Num_Proc_HEA=left(@Fatura,16) and EA.ID_DC = FD.ID_DC
--				Left Join PO_HEM EM  on EM.Num_Proc_HEM=left(@Fatura,16) and EM.ID_DC = FD.ID_DC
--				Left Join PO_HEO EO  on EO.Num_Proc_HEO=left(@Fatura,16) and EO.ID_DC = FD.ID_DC
--				Left Join PO_HIA IA  on IA.Num_Proc_HIA=left(@Fatura,16) and IA.ID_DC = FD.ID_DC
--				Left Join PO_HIM IM  on IM.Num_Proc_HIM=left(@Fatura,16) and IM.ID_DC = FD.ID_DC
--				Left Join PO_HIO PIO on PIO.Num_Proc_HIO=left(@Fatura,16) and PIO.ID_DC = FD.ID_DC
				Left Join PO_Master MAS on MAS.Num_Proc_Master=left(@Fatura,14) and MAS.ID_DC = FD.ID_DC
			where
				Fatura_PC=@Fatura

		UNION

			select  
				TDC.Nome_DC, MAS.Numero_PO Num_Doc, MAS.Data_PO Data_Doc, '-' Anexo
			from 
				PO_Master MAS
				Join Tipo_Doc_Cliente TDC on TDC.ID_DC=MAS.ID_DC
			where 
				MAS.Num_Proc_Master=left(@Fatura,14) and MAS.ID_DC not in 
				(select ID_DC from Fatura_Docs where Fatura_PC=@Fatura)
		order by
			Data_Doc desc,
			Anexo,
			TDC.Nome_DC
	END

		






GO
