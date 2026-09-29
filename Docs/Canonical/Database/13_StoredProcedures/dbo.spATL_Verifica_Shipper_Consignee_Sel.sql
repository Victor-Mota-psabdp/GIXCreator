SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_Verifica_Shipper_Consignee_Sel]'EAWIN201303001BR','IMPSA HYDRO','',''

--select [06_Consignee Name], [05_Shipper name],[23_Notify Name] from vwHea_sel 
--where [01_BDP Reference] = 'EAWIN201303001BR' 
--and ([06_Consignee Name] = '' or [05_Shipper name] = 'IMPSA HYDRO' or [23_Notify Name] = '')

CREATE PROCEDURE [dbo].[spATL_Verifica_Shipper_Consignee_Sel]
(	
	@JOB		VARCHAR(16),
	@Shipper	VARCHAR(20),
	@Consignee	VARCHAR(20),
	@Notify		VARCHAR(20)
)
AS

IF LEN(@JOB) = 16
	BEGIN
		IF	LEFT(@JOB,2) = 'EA'
			BEGIN
				SELECT TOP 1
				[Consignee Name]
				,[Shipper name]
				,[Notify Name] 
				FROM vwATL_HEA_SEL (NOLOCK) 
				WHERE [BDP Reference] = @JOB 
				AND (
					[Consignee Name] = @Consignee 
					OR [Shipper name] = @Shipper 
					OR [Notify Name] = @Notify
					)
			END
		ELSE IF LEFT(@JOB,2) = 'EO'
			BEGIN
				SELECT TOP 1
				[Consignee Name]
				,[Shipper name]
				,[Notify Name] 
				FROM vwATL_HEO_Sel (NOLOCK) 
				WHERE [BDP Reference] = @JOB 
				AND (
					[Consignee Name] = @Consignee 
					OR [Shipper name] = @Shipper 
					OR [Notify Name] = @Notify
					)
			END
		ELSE IF LEFT(@JOB,2) = 'EM'			
			BEGIN
				SELECT TOP 1
				[Consignee Name]
				,[Shipper name]
				,[Notify Name] 
				FROM vwATL_HEM_Sel (NOLOCK) 
				WHERE [BDP Reference] = @JOB 
				AND (
					[Consignee Name] = @Consignee 
					OR [Shipper name] = @Shipper 
					OR [Notify Name] = @Notify
					)
			END
		ELSE IF LEFT(@JOB,2) = 'IA'			
			BEGIN
				SELECT TOP 1
				[Consignee Name]
				,[Shipper name]
				,[Notify Name] 
				FROM vwATL_HIA_Sel (NOLOCK) 
				WHERE [BDP Reference] = @JOB 
				AND (
					[Consignee Name] = @Consignee 
					OR [Shipper name] = @Shipper 
					OR [Notify Name] = @Notify
					)
			END
		ELSE IF LEFT(@JOB,2) = 'IO'			
			BEGIN
				SELECT TOP 1
				[Consignee Name]
				,[Shipper name]
				,[Notify Name] 
				FROM vwATL_HIO_Sel (NOLOCK) 
				WHERE [BDP Reference] = @JOB 
				AND (
					[Consignee Name] = @Consignee 
					OR [Shipper name] = @Shipper 
					OR [Notify Name] = @Notify
					)
			END
		ELSE IF LEFT(@JOB,2) = 'IM'			
			BEGIN
				SELECT TOP 1
				[Consignee Name]
				,[Shipper name]
				,[Notify Name] 
				FROM vwATL_HIM_Sel (NOLOCK) 
				WHERE [BDP Reference] = @JOB 
				AND (
					[Consignee Name] = @Consignee 
					OR [Shipper name] = @Shipper 
					OR [Notify Name] = @Notify
					)
			END
	END
ELSE IF LEN(@JOB) = 14
	BEGIN
		if LEFT(@JOB,2) = 'EA'			
				SELECT TOP 1 [04 Consignee Name],[03 Shipper Name],[05 Notify Name] from vwMasterEA_sel where [01 BDP Reference] = @JOB and ([04 Consignee Name] = @Consignee or [03 Shipper Name] = @Shipper or [05 Notify Name] = @Notify)
			
		ELSE IF LEFT(@JOB,2) = 'EM'			
				SELECT TOP 1 [04 Consignee Name],[03 Shipper Name],[05 Notify Name] from vwMasterEM_Sel where [01 BDP Reference] = @JOB and ([04 Consignee Name] = @Consignee or [03 Shipper Name] = @Shipper or [05 Notify Name] = @Notify)
			
		ELSE IF LEFT(@JOB,2) = 'IA'			
				SELECT TOP 1 [Consignee Name],[Shipper Name],[Notify Name] from vwMasterIA_sel where [BDP Reference] = @JOB and ([Consignee Name] = @Consignee or [Shipper Name] = @Shipper or [Notify Name] = @Notify )
			
		ELSE IF LEFT(@JOB,2) = 'IM'			
				SELECT TOP 1 [Consignee Name],[Shipper Name],[Notify Name] from vwMasterIM_Sel where [BDP Reference] = @JOB and ([Consignee Name] = @Consignee or [Shipper Name] = @Shipper or [Notify Name] = @Notify)
					
	END
			
		
				

GO
