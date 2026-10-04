/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20260408 (32-bit version)
 * Copyright (c) 2000 - 2026 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of Y:/EFI/OC/ACPI/SSDT-NVME.aml
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000119 (281)
 *     Revision         0x02
 *     Checksum         0xA7
 *     OEM ID           "COREv4"
 *     OEM Table ID     "COREBOOT"
 *     OEM Revision     0x20110725 (537986853)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20210930 (539035952)
 */
DefinitionBlock ("", "SSDT", 2, "COREv4", "COREBOOT", 0x20110725)
{
    External (_SB_.PCI0.RP09, DeviceObj)

    Scope (\_SB.PCI0.RP09)
    {
        Device (SSD0)
        {
            Name (_ADR, Zero)  // _ADR: Address
            Name (NVME, One)
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03                                             // .
                    })
                }

                If ((NVME == One))
                {
                    Return (Package (0x04)
                    {
                        "use-msi", 
                        One, 
                        "nvme-LPSR-during-S3-S4", 
                        One
                    })
                }
                Else
                {
                    Return (Package (0x06)
                    {
                        "use-msi", 
                        One, 
                        "sata-express-power-off", 
                        One, 
                        "ssd-off-in-S4", 
                        One
                    })
                }
            }

            Device (PRT0)
            {
                Name (_ADR, 0xFFFF)  // _ADR: Address
                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If ((Arg2 == Zero))
                    {
                        Return (Buffer (One)
                        {
                             0x03                                             // .
                        })
                    }

                    Return (Package (0x02)
                    {
                        "io-device-location", 
                        Buffer (0x04)
                        {
                            "SSD"
                        }
                    })
                }
            }
        }
    }
}

